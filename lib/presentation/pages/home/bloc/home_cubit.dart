import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/util/util.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
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

  HomeCubit({
    required this.goodsUseCases,
    required this.documentsUseCases,
    required this.supplierUseCases,
    required this.customerUseCase,
    required this.walletUseCases,
    required this.paymentUseCases,
  }) : super(HomeState.initial(state: InitialState()));

  void initState() async {
    int storeId = AppSettings.getSelectedStoreId();
    List<Good> goods = await goodsUseCases.getAllByStoreId(storeId);
    int countSupplier = await supplierUseCases.getCount(storeId);
    int countCustomer = await customerUseCase.getCount(storeId);

    List<Document> documents = await documentsUseCases.getAllByStoreId(storeId);
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
    for (Good good in goods) {
      quantityTotal += good.quantity;
    }
    List<Wallet> wallets = await walletUseCases.getAllByStoreId(storeId);
    final savedOrder = await loadWalletOrder();
    final orderedWallets = await reorderWallets(wallets, savedOrder);

    List<Payment> payments = [];
    if (orderedWallets.isNotEmpty) {
      var lastWallet = orderedWallets.last;
      payments = await getPayments(lastWallet.id!);
    }
    emit(
      state.copyWith(
        incomingColor: AppSettings.getIncomingDocumentColor(),
        outgoingColor: AppSettings.getOutgoingDocumentColor(),
        countGoods: goods.length,
        quantityTotal: quantityTotal,
        countIncomingDocument: countIncomingDocument,
        sumPriceIncomingDocument: sumPriceIncomingDocument,
        countOutgoingDocument: countOutgoingDocument,
        sumPriceOutgoingDocument: sumPriceOutgoingDocument,
        countSupplier: countSupplier,
        countCustomer: countCustomer,
        wallets: orderedWallets,
        totalBalance: wallets.fold(0.0, (sum, wallet) => sum + wallet.balance),
        payments: payments,
      ),
    );
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
    emit(state.copyWith(wallets: wallets, payments: payments));
  }

  Future<List<Payment>> getPayments(int walletId) async {
    DateTime startDateTime = DateTime.fromMicrosecondsSinceEpoch(0);
    DateTime endDateTime = DateTime.now().endOfDay();
    var payments = await paymentUseCases.getInRangeByWalletId(
      walletId,
      startDateTime,
      endDateTime,
    );
    return payments.take(3).toList();
  }

  Future<void> saveWalletOrder(List<Wallet> wallets) async {
    final prefs = await SharedPreferences.getInstance();
    final walletIds = wallets.map((w) => w.id!.toString()).toList();
    await prefs.setStringList('wallet_order', walletIds);
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

  bool isShowLowStockAlert() {
    return AppSettings.getMinimumQuantitySettings().showAlert;
  }
}
