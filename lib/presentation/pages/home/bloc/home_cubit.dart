import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/util/util.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/exception/insufficient_stock_exception.dart';
import '../../../../domain/free_limits.dart';
import '../../base/base_state.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GoodsUseCases goodsUseCases;
  final DocumentUseCases documentsUseCases;
  final SuppliersUseCase supplierUseCases;
  final CustomersUseCase customerUseCase;
  final WalletUseCases walletUseCases;
  final PaymentUseCases paymentUseCases;
  final StoresUseCase storesUseCase;

  HomeCubit({
    required this.goodsUseCases,
    required this.documentsUseCases,
    required this.supplierUseCases,
    required this.customerUseCase,
    required this.walletUseCases,
    required this.paymentUseCases,
    required this.storesUseCase,
  }) : super(
          HomeState.initial(
            state: InitialState(),
            showLowStock: AppSettings.isMinQuantityEnabled(),
          ),
        ) {
    AppSettings.goodPropertiesRevision.addListener(_onPropertiesChanged);
    AppSettings.documentPropertiesRevision.addListener(_onPropertiesChanged);
  }

  @override
  Future<void> close() {
    AppSettings.goodPropertiesRevision.removeListener(_onPropertiesChanged);
    AppSettings.documentPropertiesRevision.removeListener(_onPropertiesChanged);
    return super.close();
  }

  static List<Good> _lowStockGoods(List<Good> goods, bool enabled) => enabled
      ? goods
          .where((g) => g.minQuantity != null && g.quantity < g.minQuantity!)
          .toList()
      : <Good>[];

  void _onPropertiesChanged() {
    if (isClosed) return;
    final enabled = AppSettings.isMinQuantityEnabled();
    final low = _lowStockGoods(state.allGoods, enabled);
    emit(state.copyWith(
      showLowStock: enabled,
      lowStockGoods: low,
      lowStockCount: low.length,
      propertiesRevision: AppSettings.goodPropertiesRevision.value +
          AppSettings.documentPropertiesRevision.value,
    ));
  }

  void initState() async {
    int storeId = AppSettings.getSelectedStoreId();
    List<Good> goods = await goodsUseCases.getAllByStoreId(storeId);
    int countSupplier = await supplierUseCases.getCount(storeId);
    int countCustomer = await customerUseCase.getCount(storeId);

    List<Document> documents = await documentsUseCases.getAllByStoreId(storeId);
    if (isClosed) return;

    int countIncomingDocument = 0;
    int countOutgoingDocument = 0;
    double sumPriceIncomingDocument = 0.0;
    double sumPriceOutgoingDocument = 0.0;
    for (Document item in documents) {
      if (item.type == DocumentType.incoming) {
        countIncomingDocument++;
        sumPriceIncomingDocument += item.amount;
      } else {
        countOutgoingDocument++;
        sumPriceOutgoingDocument += item.amount;
      }
    }
    double quantityTotal = 0;
    List<Good> outOfStockGoods = [];
    final minQuantityEnabled = AppSettings.isMinQuantityEnabled();
    for (Good good in goods) {
      quantityTotal += good.quantity;
      if (good.quantity <= 0) {
        outOfStockGoods.add(good);
      }
    }
    final List<Good> lowStockGoods = _lowStockGoods(goods, minQuantityEnabled);

    List<Document> recent = List.from(documents);
    recent.sort((a, b) => b.date.compareTo(a.date));
    recent = recent.take(5).toList();

    List<Wallet> wallets = await walletUseCases.getAllByStoreId(storeId);
    if (isClosed) return;

    final savedOrder = await loadWalletOrder();
    final orderedWallets = await reorderWallets(wallets, savedOrder);

    List<Payment> allPayments = [];
    for (final wallet in orderedWallets) {
      if (wallet.id != null) {
        allPayments.addAll(await getPayments(wallet.id!, take: 1000));
      }
    }
    if (isClosed) return;

    var selectedId = state.selectedWalletId;
    if (selectedId == null || !orderedWallets.any((w) => w.id == selectedId)) {
      selectedId = orderedWallets.isNotEmpty ? orderedWallets.first.id : null;
    }

    List<Payment> payments = [];
    if (selectedId != null) {
      payments = allPayments.where((p) => p.walletId == selectedId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      payments = payments.take(5).toList();
    }

    final selectedStore = await _loadSelectedStore();
    if (isClosed) return;

    emit(
      state.copyWith(
        incomingColor: AppSettings.getIncomingDocumentColor(),
        outgoingColor: AppSettings.getOutgoingDocumentColor(),
        countGoods: goods.length,
        quantityTotal: quantityTotal,
        countDocuments: documents.length,
        countIncomingDocument: countIncomingDocument,
        sumPriceIncomingDocument: sumPriceIncomingDocument,
        countOutgoingDocument: countOutgoingDocument,
        sumPriceOutgoingDocument: sumPriceOutgoingDocument,
        countSupplier: countSupplier,
        countCustomer: countCustomer,
        wallets: orderedWallets,
        selectedWalletId: selectedId,
        totalBalance: wallets.fold(0.0, (sum, wallet) => sum + wallet.balance),
        payments: payments,
        allPayments: allPayments,
        recentDocuments: recent,
        isLoadingRecentDocuments: false,
        isLoadingWallets: false,
        allGoods: goods,
        outOfStockCount: outOfStockGoods.length,
        lowStockCount: lowStockGoods.length,
        outOfStockGoods: outOfStockGoods,
        lowStockGoods: lowStockGoods,
        showLowStock: minQuantityEnabled,
        selectedStore: selectedStore,
      ),
    );
  }

  void refreshSelectedStore() async {
    final selectedStore = await _loadSelectedStore();
    if (isClosed) return;
    emit(state.copyWith(selectedStore: selectedStore));
  }

  Future<Store> _loadSelectedStore() async {
    final storeId = AppSettings.getSelectedStoreId();
    try {
      return await storesUseCase.get(storeId);
    } catch (_) {
      final store = Store();
      store.id = storeId;
      store.name = AppSettings.getSelectedStoreName();
      return store;
    }
  }

  void selectWallet(int walletId) {
    if (state.selectedWalletId == walletId) return;
    final walletPayments = state.allPayments
        .where((payment) => payment.walletId == walletId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    emit(state.copyWith(
      selectedWalletId: walletId,
      payments: walletPayments.take(5).toList(),
    ));
  }

  void deleteWallet(Wallet item) async {
    walletUseCases.delete(item.id!);
  }

  int getSelectedStoreId() {
    return AppSettings.getSelectedStoreId();
  }

  Future<bool> isValidToAddMoreWallet() async {
    var storeId = AppSettings.getSelectedStoreId();
    int count = await walletUseCases.getCount(storeId);
    bool isPro = await RevenueCatService.isPro();
    return count < FreeLimits.walletLimit || isPro;
  }

  void onAddWalletClicked() async {
    bool isValid = await isValidToAddMoreWallet();
    if (isClosed) return;
    if (isValid) {
      int storeId = AppSettings.getSelectedStoreId();
      Wallet item = Wallet();
      item.color = 0xFF2196F3;
      item.storeId = storeId;

      emit(state.copyWith(state: OpenSaveWalletPageState(item)));
    } else {
      emit(state.copyWith(state: OpenBuySubscriptionDialogState()));
    }
  }

  String getAutoDocumentNo() {
    return AppSettings.getAutoDocumentNo(getSelectedStoreId()).toString();
  }

  void onWalletTapped(int index) async {
    List<Wallet> wallets = List.from(state.wallets);
    final wallet = wallets[index];
    wallets.removeAt(index);
    wallets.add(wallet);

    // Save the new order
    await saveWalletOrder(wallets);

    var payments = await getPayments(wallet.id!);
    if (isClosed) return;

    emit(state.copyWith(wallets: wallets, payments: payments));
  }

  Future<List<Payment>> getPayments(int walletId, {int take = 3}) async {
    DateTime startDateTime = DateTime.fromMicrosecondsSinceEpoch(0);
    DateTime endDateTime = DateTime.now().endOfDay();
    var payments = await paymentUseCases.getInRangeByWalletId(
      walletId,
      startDateTime,
      endDateTime,
    );
    return payments.take(take).toList();
  }

  Future<void> saveWalletOrder(List<Wallet> wallets) async {
    final prefs = await SharedPreferences.getInstance();
    final walletIds = wallets.map((w) => w.id!.toString()).toList();
    await prefs.setStringList('wallet_order', walletIds);
  }

  Future<void> deleteDocument(int id) async {
    try {
      await documentsUseCases.delete(id);
    } on InsufficientStockException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(state: InsufficientStockError(e)));
      return;
    }
    initState();
  }

  Future<Payment> createPaymentDraft(Document item) async {
    final payment = Payment();
    payment.type = item.type == DocumentType.incoming
        ? PaymentType.outbound
        : PaymentType.inbound;
    payment.storeId = AppSettings.getSelectedStoreId();
    payment.walletId = AppSettings.getSavePaymentLastSelectedWalletId();
    payment.documentId = item.id;
    payment.document = item;

    if (item.type == DocumentType.incoming) {
      if (item.personId != null) {
        payment.supplierId = item.personId;
        payment.supplier = await supplierUseCases.get(item.personId!);
      }
    } else if (item.personId != null) {
      payment.customerId = item.personId;
      payment.customer = await customerUseCase.get(item.personId!);
    }
    return payment;
  }

  Future<List<String>> loadWalletOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('wallet_order') ?? [];
  }

  Future<List<Wallet>> reorderWallets(
    List<Wallet> wallets,
    List<String> savedOrder,
  ) async {
    final walletMap = {for (var w in wallets) w.id.toString(): w};
    final ordered = <Wallet>[];
    for (final id in savedOrder) {
      if (walletMap.containsKey(id)) {
        ordered.add(walletMap[id]!);
        walletMap.remove(id);
      }
    }
    ordered.addAll(walletMap.values);
    return ordered;
  }
}
