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

  Future<bool> syncLocalToNetwork() async {
    try {
      final stores = await storesRepository.getAll();
      //update network Id
      for (var store in stores) {
        if (store.networkId.isEmpty) {
          final uuid = await nanoid(6);
          store.networkId = uuid;
          storesRepository.update(store);
        }
      }

      //update stores
      for (var store in stores) {
        final storeId = store.networkId;
        DatabaseReference ref = FirebaseDatabase.instance.ref("stores/$storeId");

        final localStoreId = store.id!;
        final suppliers =
            await suppliersRepository.getAllByStoreId(localStoreId);
        final customers =
            await customersRepository.getAllByStoreId(localStoreId);
        final groups = await groupsRepository.getAllByStoreId(localStoreId);
        final goods = await goodsRepository.getAllByStoreId(localStoreId);
        final documents =
            await documentRepository.getAllByStoreId(localStoreId);
        final documentTransactions =
            await documentTransactionRepository.getAllByStoreId(localStoreId);

        for (var good in goods) {
          double totalQuantity = 0;
          final transactions =
              documentTransactions.where((t) => t.goodId == good.id);
          for (var t in transactions) {
            if (t.type == DocumentType.incoming) {
              totalQuantity += t.quantity;
            } else if (t.type == DocumentType.outgoing) {
              totalQuantity -= t.quantity;
            }
          }
          good.quantity = totalQuantity;
        }

        final paymentCategories = await paymentCategoryRepository.getAll();
        final wallet = await walletRepository.getAllByStoreId(localStoreId);
        final payments = await paymentRepository.getAllByStoreId(localStoreId);

        for (var document in documents) {
          double totalQuantity = 0;
          double totalAmount = 0;
          final transactions =
              documentTransactions.where((t) => t.documentId == document.id);
          for (var t in transactions) {
            totalQuantity += t.quantity;
            totalAmount += t.quantity * (t.price ?? 0);
          }
          document.quantity = totalQuantity;
          document.amount = totalAmount;

          double totalPaid = 0;
          final documentPayments =
              payments.where((p) => p.documentId == document.id);
          for (var p in documentPayments) {
            totalPaid += p.amount ?? 0;
          }
          document.paid = totalPaid;
        }

        final user = FirebaseAuth.instance.currentUser;
        final email = user?.email ?? "na";
        final uid = user?.uid;

        if (uid != null) {
          await FirebaseDatabase.instance.ref().update({
            "store_members/$uid/$storeId": "admin",
            "store_users/$storeId/$uid": "admin"
          });
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
            wallet,
            paymentCategories,
            payments);
        final json = entity.toJson();
        await ref.set(json);
      }
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
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
