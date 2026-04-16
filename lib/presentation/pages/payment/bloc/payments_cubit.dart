import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:good_manager/presentation/criteria/and_criteria.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';
import 'package:good_manager/presentation/criteria/or_criteria.dart';
import 'package:good_manager/presentation/pages/payment/criteria/by_category_criteria.dart';
import 'package:good_manager/presentation/pages/payment/criteria/by_customer_criteria.dart';
import 'package:good_manager/presentation/pages/payment/criteria/by_supplier_criteria.dart';
import 'package:good_manager/presentation/pages/payment/criteria/by_type_criteria.dart';
import 'package:good_manager/presentation/pages/payment/criteria/by_wallet_criteria.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';
import '../criteria/by_date_criteria.dart';

part 'payments_cubit.freezed.dart';
part 'payments_state.dart';

@injectable
class PaymentsCubit extends Cubit<PaymentsState> {
  //final Storage storage;
  final DocumentUseCases documentUseCases;
  final PaymentUseCases useCase;
  final PaymentCategoryUseCases paymentCategoryUseCases;

  PaymentsCubit({
    required this.useCase,
    required this.documentUseCases,
    required this.paymentCategoryUseCases,
  }) : super(PaymentsState.initial(state: InitialState()));

  void init(PaymentsSetting? setting) {
    if (setting != null) {
      emit(state.copyWith(state: LoadingState(), setting: setting));
    } else {
      emit(
        state.copyWith(
          state: LoadingState(),
          setting: AppSettings.getPaymentsSetting(),
        ),
      );
    }
    loadItems();
  }

  void onAddInboundPayment() {
    Payment item = Payment();
    item.type = PaymentType.inbound;
    item.storeId = AppSettings.getSelectedStoreId();
    item.walletId = AppSettings.getSavePaymentLastSelectedWalletId();
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }

  void onAddOutboundPayment() {
    Payment item = Payment();
    item.type = PaymentType.outbound;
    item.storeId = AppSettings.getSelectedStoreId();
    item.walletId = AppSettings.getSavePaymentLastSelectedWalletId();
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }

  void onPaymentPressed(Payment item) {
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }

  void loadItems() async {
    int storeId = AppSettings.getSelectedStoreId();
    List<Payment> payments = await useCase.getAllByStoreId(storeId);
    List<PaymentCategory?> categories = payments
        //.where((payment) => payment.category != null)
        .map((payment) => payment.category)
        .toSet()
        .toList();
    List<Wallet> wallets = payments
        .where((payment) => payment.wallet != null)
        .map((payment) => payment.wallet!)
        .toSet()
        .toList();

    List<Customer> customers = payments
        .where((payment) => payment.customer != null)
        .map((payment) => payment.customer!)
        .toSet()
        .toList();

    List<Supplier> suppliers = payments
        .where((payment) => payment.supplier != null)
        .map((payment) => payment.supplier!)
        .toSet()
        .toList();

    emit(
      state.copyWith(
        state: LoadSuccessState(),
        allPayments: payments,
        categories: categories,
        wallets: wallets,
        customers: customers,
        suppliers: suppliers,
      ),
    );

    update();
  }

  Future<void> delete(int id) async {
    await useCase.delete(id);
    loadItems();
  }

  void resetAllFilter() {
    var setting = PaymentsSetting.getDefault();
    emit(state.copyWith(setting: setting));
    AppSettings.setPaymentsSetting(setting);
    update();
  }

  void applyFilter(PaymentsSetting setting) {
    emit(state.copyWith(setting: setting));
    AppSettings.setPaymentsSetting(setting);
    update();
  }

  void update() {
    List<Criteria<Payment>> commonCriteria = [];
    if (state.setting?.selectedCategoryIds != null &&
        state.setting!.selectedCategoryIds.isNotEmpty) {
      List<Criteria<Payment>> categoryCriteria = [];
      state.setting!.selectedCategoryIds.forEach((id) {
        categoryCriteria.add(ByCategoryCriteria(id));
        ;
      });
      commonCriteria.add(OrCriteria(categoryCriteria));
    }
    if (state.setting!.selectedWalletIds.isNotEmpty) {
      List<Criteria<Payment>> walletCriteria = [];
      state.setting!.selectedWalletIds.forEach((id) {
        walletCriteria.add(ByWalletCriteria(id));
        ;
      });
      commonCriteria.add(OrCriteria(walletCriteria));
    }
    if (state.setting!.selectedCustomerIds.isNotEmpty) {
      List<Criteria<Payment>> criteriaList = [];
      state.setting!.selectedCustomerIds.forEach((id) {
        criteriaList.add(ByCustomerCriteria(id));
      });
      commonCriteria.add(OrCriteria(criteriaList));
    }
    if (state.setting!.selectedSupplierIds.isNotEmpty) {
      List<Criteria<Payment>> criteriaList = [];
      state.setting!.selectedSupplierIds.forEach((id) {
        criteriaList.add(BySupplierCriteria(id));
      });
      commonCriteria.add(OrCriteria(criteriaList));
    }
    if (state.setting?.startDate != null && state.setting?.endDate != null) {
      commonCriteria.add(
        ByDateCriteria(state.setting!.startDate!, state.setting!.endDate!),
      );
    }
    List<Criteria<Payment>> inboundCriteria = List.from(commonCriteria);
    inboundCriteria.add(ByTypeCriteria(PaymentType.inbound));

    List<Criteria<Payment>> outboundCriteria = List.from(commonCriteria);
    outboundCriteria.add(ByTypeCriteria(PaymentType.outbound));

    List<Payment> payments =
        AndCriteria<Payment>(commonCriteria).meetCriteria(state.allPayments);
    List<Payment> inboundPayments =
        AndCriteria<Payment>(inboundCriteria).meetCriteria(state.allPayments);
    List<Payment> outboundPayments =
        AndCriteria<Payment>(outboundCriteria).meetCriteria(state.allPayments);

    emit(
      state.copyWith(
        state: LoadSuccessState(),
        payments: payments,
        inboundPayments: inboundPayments,
        outboundPayments: outboundPayments,
      ),
    );
  }
}
