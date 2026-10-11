import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:good_manager/data/realtime/store_realtime_entity.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/repo/repo.dart';
import 'package:nanoid/async.dart';

class DbServiceRealtime {
  final StoresRepository storesRepository;
  final SuppliersRepository suppliersRepository;
  final CustomersRepository customersRepository;
  final GroupsRepository groupsRepository;
  final GoodsRepository goodsRepository;
  final DocumentRepository documentRepository;
  final DocumentTransactionRepository documentTransactionRepository;

  //payment
  final PaymentCategoryRepository paymentCategoryRepository;
  final WalletRepository walletRepository;
  final PaymentRepository paymentRepository;

  DbServiceRealtime(
      this.storesRepository,
      this.suppliersRepository,
      this.customersRepository,
      this.groupsRepository,
      this.goodsRepository,
      this.documentRepository,
      this.documentTransactionRepository,
      this.paymentCategoryRepository,
      this.walletRepository,
      this.paymentRepository);

  Future<String?> syncLocalToNetwork() async {
    try {
      final stores = await storesRepository.getAll();
      
      // Update missing network IDs first (Concurrent)
      await Future.wait(stores.map((store) async {
        if (store.networkId.isEmpty) {
          store.networkId = await nanoid(6);
          await storesRepository.update(store);
        }
      }));

      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email ?? "na";
      final uid = user?.uid;

      // Hoist global data fetching
      final paymentCategories = await paymentCategoryRepository.getAll();
      final Map<String, dynamic> globalMembershipUpdates = {};

      for (var store in stores) {
        final storeId = store.networkId;
        final localStoreId = store.id!;
        
        // Concurrent local data fetching
        final results = await Future.wait([
          suppliersRepository.getAllByStoreId(localStoreId),
          customersRepository.getAllByStoreId(localStoreId),
          groupsRepository.getAllByStoreId(localStoreId),
          goodsRepository.getAllByStoreId(localStoreId),
          documentRepository.getAllByStoreId(localStoreId),
          documentTransactionRepository.getAllByStoreId(localStoreId),
          walletRepository.getAllByStoreId(localStoreId),
          paymentRepository.getAllByStoreId(localStoreId),
        ]);

        final suppliers = results[0] as List<Supplier>;
        final customers = results[1] as List<Customer>;
        final groups = results[2] as List<Group>;
        final goods = results[3] as List<Good>;
        final documents = results[4] as List<Document>;
        final documentTransactions = results[5] as List<DocumentTransaction>;
        final wallets = results[6] as List<Wallet>;
        final payments = results[7] as List<Payment>;

        // Optimization: Map-based aggregation (O(T) vs O(G*T))
        final Map<int, double> goodQuantities = {};
        final Map<int, double> docQuantities = {};
        final Map<int, double> docAmounts = {};
        
        for (var tx in documentTransactions) {
          double change = (tx.type == DocumentType.incoming) ? tx.quantity : -tx
              .quantity;
          goodQuantities[tx.goodId] = (goodQuantities[tx.goodId] ?? 0) + change;
          docQuantities[tx.documentId] =
              (docQuantities[tx.documentId] ?? 0) + tx.quantity;
          docAmounts[tx.documentId] = (docAmounts[tx.documentId] ?? 0) +
              (tx.quantity * (tx.price ?? 0));
        }

        final Map<int, double> docPaid = {};
        for (var p in payments) {
          if (p.documentId != null) {
            docPaid[p.documentId!] = (docPaid[p.documentId!] ?? 0) + (p.amount ?? 0);
          }
        }

        // Apply calculated values O(G + D)
        for (var good in goods) {
          good.quantity = goodQuantities[good.id] ?? 0;
        }

        for (var document in documents) {
          document.quantity = docQuantities[document.id] ?? 0;
          document.amount = docAmounts[document.id] ?? 0;
          document.paid = docPaid[document.id] ?? 0;
        }

        if (uid != null) {
          globalMembershipUpdates["store_members/$uid/$storeId"] = "admin";
          globalMembershipUpdates["store_users/$storeId/$uid"] = "admin";
        }

        final entity = getStoreRealtimeEntity(
            email,
            store,
            suppliers,
            customers,
            groups,
            goods,
            documents,
              documentTransactions,
              wallets,
              paymentCategories,
              payments);

          // Network write with timeout
          await FirebaseDatabase.instance.ref("stores/$storeId")
              .set(entity.toJson())
              .timeout(const Duration(seconds: 120));

           final goodsRef = FirebaseDatabase.instance.ref("stores/$storeId/goods");

           for (final item in entity.goods) {
             await goodsRef.child(item.id.toString()).set(item.toMapV2());
           }
      }

      // Batch membership updates
      if (globalMembershipUpdates.isNotEmpty) {
        await FirebaseDatabase.instance.ref().update(globalMembershipUpdates)
            .timeout(const Duration(seconds: 30));
      }

      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'sync_migration_success',
        parameters: {
          'store_count': stores.length,
        },
      ));

      return null;
    } on TimeoutException catch (e) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'sync_migration_failed',
        parameters: {
          'reason': 'timeout',
          'error': e.toString(),
        },
      ));
      return "sync_timeout".tr();
    } catch (e) {
      unawaited(FirebaseAnalytics.instance.logEvent(
        name: 'sync_migration_failed',
        parameters: {
          'reason': 'exception',
          'error': e.toString(),
        },
      ));
      return e.toString();
    }
  }

  StoreRealtimeEntity getStoreRealtimeEntity(
      String email,
      Store store,
      List<Supplier> suppliers,
      List<Customer> customers,
      List<Group> groups,
      List<Good> goods,
      List<Document> documents,
      List<DocumentTransaction> documentTransactions,
      List<Wallet> wallets,
      List<PaymentCategory> paymentCategories,
      List<Payment> payments) {
    StoreRealtimeEntity entity = StoreRealtimeEntity();
    entity.networkId = store.networkId;
    entity.name = store.name;
    entity.description = store.description;
    entity.createdDate = store.createdDate;
    entity.updatedDate = store.updatedDate;

    entity.suppliers = suppliers;
    entity.customers = customers;
    entity.groups = groups;
    entity.goods = goods;
    entity.documents = documents;
    entity.documentTransactions =
        _groupTransactionsByDocument(documentTransactions);

    entity.wallets = wallets;
    entity.paymentCategories = paymentCategories;
    entity.payments = payments;

    return entity;
  }

  Map<String, List<DocumentTransaction>> _groupTransactionsByDocument(
      List<DocumentTransaction> transactions) {
    final Map<String, List<DocumentTransaction>> map = {};

    for (var tx in transactions) {
      final docId = tx.documentId.toString();

      if (!map.containsKey(docId)) {
        map[docId] = [];
      }

      map[docId]!.add(tx);
    }

    return map;
  }
}
