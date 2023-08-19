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
  void init(int documentId){
    emit(state.copyWith(documentId: documentId));
    loadInvoiced();
    loadItems();
  }
  void loadInvoiced() async{
    List<DocumentTransaction> transactions = await documentUseCases.getTransactionsByDocumentId(state.documentId!);
    double invoiced = 0.0;
    for (DocumentTransaction transaction in transactions){
      invoiced += transaction.quantity * transaction.price;
    }
    emit(state.copyWith(invoiced: invoiced));
  }
  void onAddNewPaymentButtonPressed(){
    Payment item = Payment();
    item.documentId = state.documentId!;
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }

  void onPaymentPressed(Payment item) {
    emit(state.copyWith(state: OpenSavePaymentPageState(item)));
  }
  void loadItems() async{
    List<Payment> payments = await useCase.getByDocumentId(state.documentId!);
    double paid = 0.0;
    for (Payment payment in payments){
      paid += payment.amount;
    }
    emit(state.copyWith(items: payments, paid: paid));
  }
  delete(int id) async{
    await useCase.delete(id);
    loadItems();
  }
}
