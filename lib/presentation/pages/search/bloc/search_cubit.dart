import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';

part 'search_cubit.freezed.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final GoodsUseCases goodsUseCases;
  final DocumentUseCases documentUseCases;
  final PaymentUseCases paymentUseCases;
  final GroupsUseCases groupsUseCases;
  final WalletUseCases walletUseCases;

  SearchCubit({
    required this.goodsUseCases,
    required this.documentUseCases,
    required this.paymentUseCases,
    required this.groupsUseCases,
    required this.walletUseCases,
  }) : super(
          SearchState.initial(
            state: InitialState(),
            incomingColor: AppSettings.getIncomingDocumentColor(),
            outgoingColor: AppSettings.getOutgoingDocumentColor(),
          ),
        );

  List<Good> _allGoods = [];
  List<Document> _allDocs = [];
  List<Payment> _allPayments = [];
  List<Group> _allGroups = [];
  List<Wallet> _allWallets = [];

  Future<void> init() async {
    final storeId = AppSettings.getSelectedStoreId();
    _allGoods = await goodsUseCases.getAllByStoreId(storeId);
    _allDocs = await documentUseCases.getAllByStoreId(storeId);
    _allPayments = await paymentUseCases.getAllByStoreId(storeId);
    _allGroups = await groupsUseCases.getAllByStoreId(storeId);
    _allWallets = await walletUseCases.getAllByStoreId(storeId);
    if (isClosed) return;
    _performSearch();
  }

  void onSearchTextChanged(String query) {
    emit(state.copyWith(query: query));
    if (query.isEmpty) {
      emit(state.copyWith(
        goods: [],
        documents: [],
        payments: [],
        groups: [],
        wallets: [],
      ));
      return;
    }
    _performSearch();
  }

  void _performSearch() {
    final query = state.query.toLowerCase();
    if (query.isEmpty) return;

    final goods = _allGoods.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          (item.barCode?.toLowerCase().contains(query) ?? false);
    }).toList();

    final docs = _allDocs.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          (item.personName?.toLowerCase().contains(query) ?? false);
    }).toList();

    final payments = _allPayments.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          (item.category?.name.toLowerCase().contains(query) ?? false);
    }).toList();

    final groups = _allGroups.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
    }).toList();

    final wallets = _allWallets.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(
      goods: goods,
      documents: docs,
      payments: payments,
      groups: groups,
      wallets: wallets,
    ));
  }
}
