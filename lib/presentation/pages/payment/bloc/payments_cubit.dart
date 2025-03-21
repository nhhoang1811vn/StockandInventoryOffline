import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/transaction.dart';
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

  void onAddIncomingPayment(){
    Payment item = Payment();
    item.documentType = DocumentType.incoming;
    item.storeId = storage.getSelectedStoreId();
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void onAddOutgoingPayment(){
    Payment item = Payment();
    item.documentType = DocumentType.outgoing;
    item.storeId = storage.getSelectedStoreId();
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void onPaymentPressed(Payment item) {
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void loadItems() async{
    int storeId = storage.getSelectedStoreId();
    List<Payment> payments = await useCase.getAllByStoreId(storeId);
    List<Payment> incomingPayments = payments.where((item) => item.documentType == DocumentType.incoming).toList();
    List<Payment> outgoingPayments = payments.where((item) => item.documentType == DocumentType.outgoing).toList();
    emit(state.copyWith(state: LoadSuccessState(),incomingItems: incomingPayments, outgoingItems: outgoingPayments));
  }
  delete(int id) async{
    await useCase.delete(id);
    loadItems();
  }
}
