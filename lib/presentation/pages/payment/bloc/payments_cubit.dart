import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/storage.dart';
import '../../../../domain/entities/payment.dart';
import '../../../../domain/usecases/payment/payment_usercases.dart';
import '../../base/base_state.dart';

part 'payments_cubit.freezed.dart';
part 'payments_state.dart';

@injectable
class PaymentsCubit extends Cubit<PaymentsState> {
  final Storage storage;
  final DocumentUseCases documentUseCases;
  final PaymentUseCases useCase;
  PaymentsCubit({
    required this.storage,
    required this.useCase,
    required this.documentUseCases
  }) : super(PaymentsState.initial(state: InitialState()));
  void init(){
    emit(state.copyWith(state: LoadingState()));
    loadItems();
  }

  void onAddInboundPayment(){
    Payment item = Payment();
    item.type = PaymentType.inbound;
    item.storeId = storage.getSelectedStoreId();
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void onAddOutboundPayment(){
    Payment item = Payment();
    item.type = PaymentType.outbound;
    item.storeId = storage.getSelectedStoreId();
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void onPaymentPressed(Payment item) {
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void loadItems() async{
    int storeId = storage.getSelectedStoreId();
    List<Payment> payments = await useCase.getAllByStoreId(storeId);
    List<Payment> inboundPayments = payments.where((item) => item.type == PaymentType.inbound).toList();
    List<Payment> outboundPayments = payments.where((item) => item.type == PaymentType.outbound).toList();
    emit(state.copyWith(state: LoadSuccessState(),inboundItems: inboundPayments, outboundItems: outboundPayments));
  }
  delete(int id) async{
    await useCase.delete(id);
    loadItems();
  }
}
