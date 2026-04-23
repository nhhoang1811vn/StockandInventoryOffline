import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/data/realtime/db_service_realtime.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:good_manager/repo/repo.dart';
import 'package:injectable/injectable.dart';

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

  Future<bool> syncToRealtimeDB() {
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
    return service.syncLocalToNetwork();
  }
}
