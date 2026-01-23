import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/realtime/db_service_realtime.dart';
import 'package:good_manager/domain/entity/document.dart';
import 'package:good_manager/domain/usecase/customers/customers_usecases.dart';
import 'package:good_manager/domain/usecase/documents/document_usecases.dart';
import 'package:good_manager/domain/usecase/goods/goods_usercases.dart';
import 'package:good_manager/domain/usecase/groups/groups_usecases.dart';
import 'package:good_manager/domain/usecase/stores/stores_usecases.dart';
import 'package:good_manager/domain/usecase/suppliers/suppliers_usecases.dart';
import 'package:good_manager/repo/repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/app_settings.dart';
import '../../../../../models/currency.dart';

part 'settings_data_cubit.freezed.dart';

part 'settings_data_state.dart';

@injectable
class SettingsDataCubit extends Cubit<SettingsDataState> {
  final StoresRepository storesRepository;
  final SuppliersRepository suppliersRepository;
  final CustomersRepository customersRepository;

  final GroupsRepository groupsRepository;
  final GoodsRepository goodsRepository;
  final DocumentRepository documentRepository;
  final DocumentTransactionRepository documentTransactionRepository;

  final PaymentCategoryRepository paymentCategoryRepository;
  final WalletRepository walletRepository;
  final PaymentRepository paymentRepository;

  SettingsDataCubit(
      this.storesRepository,
      this.suppliersRepository,
      this.customersRepository,
      this.groupsRepository,
      this.goodsRepository,
      this.documentRepository,
      this.documentTransactionRepository,
      this.paymentCategoryRepository,
      this.walletRepository,
      this.paymentRepository
      )
      : super(SettingsDataState.initial());

  void syncToRealtimeDB() {
    final service = DbServiceRealtime(
        storesRepository,
        suppliersRepository,
        customersRepository,
        groupsRepository,
        goodsRepository,

        documentRepository,
        documentTransactionRepository,

        paymentCategoryRepository,
        walletRepository,
        paymentRepository

    );
    service.syncLocalToNetwork();
  }
}
