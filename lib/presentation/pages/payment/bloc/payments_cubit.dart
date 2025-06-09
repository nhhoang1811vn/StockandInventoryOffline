import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/payment_category.dart';
import 'package:good_manager/domain/entities/wallet.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:good_manager/domain/usecases/payment_category/payment_category_usercases.dart';
import 'package:good_manager/presentation/criteria/and_criteria.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';
import 'package:good_manager/presentation/models/list_item.dart';
import 'package:good_manager/presentation/pages/payment/criteria/by_category_criteria.dart';
import 'package:good_manager/presentation/pages/payment/criteria/by_type_criteria.dart';
import 'package:good_manager/presentation/pages/payment/criteria/by_wallet_criteria.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/payment.dart';
import '../../../../domain/entities/payments_setting.dart';
import '../../../../domain/usecases/payment/payment_usercases.dart';
import '../../base/base_state.dart';
import '../criteria/by_date_criteria.dart';

part 'payments_cubit.freezed.dart';
part 'payments_state.dart';

@injectable
class PaymentsCubit extends Cubit<PaymentsState> {
  final Storage storage;
  final AppSettings appSettings;
  final DocumentUseCases documentUseCases;
  final PaymentUseCases useCase;
  final PaymentCategoryUseCases paymentCategoryUseCases;

  PaymentsCubit(
      {required this.storage,
      required this.appSettings,
      required this.useCase,
      required this.documentUseCases,
      required this.paymentCategoryUseCases})
      : super(PaymentsState.initial(
            state: InitialState()));

  void init(PaymentsSetting? setting) {
    if (setting != null){
      emit(state.copyWith(state: LoadingState(), setting: setting));
    }else{
      emit(state.copyWith(state: LoadingState(), setting: appSettings.getPaymentsSetting()));
    }
    loadItems();
  }
  void onAddInboundPayment() {
    Payment item = Payment();
    item.type = PaymentType.inbound;
    item.storeId = storage.getSelectedStoreId();
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void onAddOutboundPayment() {
    Payment item = Payment();
    item.type = PaymentType.outbound;
    item.storeId = storage.getSelectedStoreId();
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void onPaymentPressed(Payment item) {
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void loadItems() async {
    int storeId = storage.getSelectedStoreId();
    List<Payment> payments = await useCase.getAllByStoreId(storeId);
    List<PaymentCategory> categories = payments
        .where((payment) => payment.category != null)
        .map((payment) => payment.category!)
        .toSet()
        .toList();
    List<Wallet> wallets = payments
        .where((payment) => payment.wallet != null)
        .map((payment) => payment.wallet!)
        .toSet()
        .toList();
    emit(state.copyWith(
        state: LoadSuccessState(),
        payments: payments,
        categories: categories,
        wallets: wallets));

    update();
  }
  delete(int id) async {
    await useCase.delete(id);
    loadItems();
  }

  void resetAllFilter() {
    var setting = PaymentsSetting.getDefault();
    emit(state.copyWith(setting: setting));
    appSettings.setPaymentsSetting(setting);
    update();
  }
  void applyFilter(PaymentsSetting setting){
    emit(state.copyWith(setting: setting));
    appSettings.setPaymentsSetting(setting);
    update();
  }
  void update(){
    List<Criteria<Payment>> commonCriteria = [];
    if (state.setting?.selectedCategoryId != null){
      commonCriteria.add(ByCategoryCriteria(state.setting!.selectedCategoryId!));
    }
    if (state.setting?.selectedWalletId != null){
      commonCriteria.add(ByWalletCriteria(state.setting!.selectedWalletId!));
    }
    if (state.setting?.startDate != null && state.setting?.endDate != null){
      commonCriteria.add(ByDateCriteria(state.setting!.startDate!, state.setting!.endDate!));
    }
    List<Criteria<Payment>> inboundCriteria = List.from(commonCriteria);
    inboundCriteria.add(ByTypeCriteria(PaymentType.inbound));

    List<Criteria<Payment>> outboundCriteria = List.from(commonCriteria);
    outboundCriteria.add(ByTypeCriteria(PaymentType.outbound));

    List<Payment> payments = AndCriteria<Payment>(commonCriteria).meetCriteria(state.payments);
    List<Payment> inboundPayments = AndCriteria<Payment>(inboundCriteria).meetCriteria(state.payments);
    List<Payment> outboundPayments = AndCriteria<Payment>(outboundCriteria).meetCriteria(state.payments);

    emit(state.copyWith(
        state: LoadSuccessState(),
        items: getListItems(payments),
        inboundItems: getListItems(inboundPayments),
        outboundItems: getListItems(outboundPayments)));
  }
  List<ListItem> getListItems(List<Payment> payments) {
    List<ListItem> groupedList = [];

    // Sort by date if needed
    //payments.sort((a, b) => a.date.compareTo(b.date));
    DateTime? currentGroupDate;

    for (var payment in payments) {
      DateTime paymentDate = DateTime(payment.date.year, payment.date.month, payment.date.day);

      if (currentGroupDate == null || currentGroupDate != paymentDate) {
        currentGroupDate = paymentDate;
        groupedList.add(HeaderItem(paymentDate));
      }
      groupedList.add(PaymentListItem(payment));
    }

    return groupedList;
  }
}
