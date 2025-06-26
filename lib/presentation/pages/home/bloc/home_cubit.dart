import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/domain/usecases/wallets/wallet_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/document.dart';
import '../../../../domain/entities/good.dart';
import '../../../../domain/free_limits.dart';
import '../../../../domain/usecases/customers/customers_usecases.dart';
import '../../../../domain/usecases/documents/document_usecases.dart';
import '../../../../domain/usecases/goods/goods_usercases.dart';
import '../../../../domain/usecases/suppliers/suppliers_usecases.dart';
import '../../../../revenuecat_purchase_manager.dart';
import '../../base/base_state.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final Storage storage;
  final GoodsUseCases goodsUseCases;
  final DocumentUseCases documentsUseCases;
  final SuppliersUseCase supplierUseCases;
  final CustomersUseCase customerUseCase;
  final WalletUseCases walletUseCases;
  final AppSettings appSettings;

  HomeCubit({
    required this.storage,
    required this.goodsUseCases,
    required this.documentsUseCases,
    required this.supplierUseCases,
    required this.customerUseCase,
    required this.walletUseCases,
    required this.appSettings,
  }) : super(HomeState.initial(state: InitialState()));

  void initState() async {
    int storeId = storage.getSelectedStoreId();
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
    emit(state.copyWith(
        incomingColor: appSettings.getIncomingDocumentColor(),
        outgoingColor: appSettings.getOutgoingDocumentColor(),
        countGoods: goods.length,
        quantityTotal: quantityTotal,
        countIncomingDocument: countIncomingDocument,
        sumPriceIncomingDocument: sumPriceIncomingDocument,
        countOutgoingDocument: countOutgoingDocument,
        sumPriceOutgoingDocument: sumPriceOutgoingDocument,
        countSupplier: countSupplier,
        countCustomer: countCustomer,
        wallets: wallets,
        totalBalance: wallets.fold(0.0, (sum, wallet) => sum + wallet.balance)));
  }

  void deleteWallet(Wallet item) async {
    walletUseCases.delete(item.id!);
  }

  getSelectedStoreId() {
    return storage.getSelectedStoreId();
  }
  Future<bool> isValidToAddMoreWallet() async{
    var storeId = storage.getSelectedStoreId();
    int count = await walletUseCases.getCount(storeId);
    bool isPro = await RevenueCatService.isPro();
    return count < FreeLimits.walletLimit || isPro;
  }
  void onAddWalletClicked() async{
    bool isValid = await isValidToAddMoreWallet();
    if (isValid){
      int storeId = storage.getSelectedStoreId();
      Wallet item = Wallet();
      item.color = Colors.blue.toARGB32();
      item.storeId = storeId;

      emit(state.copyWith(state: OpenSaveWalletPageState(item)));
    }else{
      emit(state.copyWith(state: OpenBuySubscriptionDialogState()));
    }
  }
  //void on

  String getAutoDocumentNo() {
    return storage.getAutoDocumentNo(getSelectedStoreId()).toString();
  }
}
