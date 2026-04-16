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

  Future<void> syncLocalToNetwork() async {
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
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("stores/${store.networkId}");

      final localStoreId = store.id!;
      final suppliers = await suppliersRepository.getAllByStoreId(localStoreId);
      final customers = await customersRepository.getAllByStoreId(localStoreId);
      final groups = await groupsRepository.getAllByStoreId(localStoreId);
      final goods = await goodsRepository.getAllByStoreId(localStoreId);
      final documents = await documentRepository.getAllByStoreId(localStoreId);
      final documentTransactions =
          await documentTransactionRepository.getAllByStoreId(localStoreId);

      final paymentCategories = await paymentCategoryRepository.getAll();
      final wallet = await walletRepository.getAllByStoreId(localStoreId);
      final payments = await paymentRepository.getAllByStoreId(localStoreId);

      final email = FirebaseAuth.instance.currentUser?.email ?? "na";
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
    entity.localId = store.id!;
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
    entity.documentTransactions = documentTransactions;

    entity.wallets = wallets;
    entity.paymentCategories = paymentCategories;
    entity.payments = payments;

    List<MemberEntity> members = [];
    final memberEntity = MemberEntity();
    memberEntity.email = email;
    memberEntity.role = "admin";
    members.add(memberEntity);
    entity.members = members;

    return entity;
  }
}
