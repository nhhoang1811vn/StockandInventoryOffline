import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/app_settings.dart';
import 'package:good_manager/domain/entities/good_history.dart';
import 'package:good_manager/domain/entities/payment.dart';
import 'package:good_manager/domain/usecases/documents/document_usecases.dart';
import 'package:good_manager/domain/usecases/payment/payment_usercases.dart';
import 'package:good_manager/presentation/models/list_item.dart';
import 'package:good_manager/presentation/pages/base/base_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/document.dart';

part 'documents_history_cubit.freezed.dart';
part 'documents_history_state.dart';

@injectable
class DocumentsHistoryCubit extends Cubit<DocumentsHistoryState>{
  final DocumentUseCases documentUseCases;
  final PaymentUseCases paymentUseCases;
  final AppSettings appSettings;
  DocumentsHistoryCubit({
    required this.documentUseCases,
    required this.paymentUseCases,
    required this.appSettings
    //required this.documentTransactionRepository
  }) : super(DocumentsHistoryState.initial(
      state: InitialState(),
      incomingColor: appSettings.getIncomingDocumentColor(),
    outgoingColor: appSettings.getOutgoingDocumentColor()
  ));
  void initState(int? supplierId, int? customerId, DateTime? start, DateTime? end){
    emit(state.copyWith(supplierId: supplierId, customerId: customerId, start: start, end: end));
    loadItems();
  }
  loadItems() async{
    DateTime startDateTime = DateTime.fromMicrosecondsSinceEpoch(0);
    DateTime endDateTime = DateTime.now();
    if (state.start != null){
      startDateTime = state.start!;
    }
    if (state.end != null) {
      endDateTime = state.end!;
    }
    List<Document> documents = [];
    if (state.supplierId != null){
      documents = await documentUseCases.getInRangeBySupplierId(state.supplierId!, startDateTime, endDateTime);
    }else if (state.customerId != null){
      documents = await documentUseCases.getInRangeByCustomerId(state.customerId!, startDateTime, endDateTime);
    }
    var items = await getListItems(documents);
    emit(state.copyWith(items : items));
  }
  Future<List<ListItem>> getListItems(List<Document> documents) async{
    List<ListItem> groupedList = [];
    // Sort by date if needed
    //payments.sort((a, b) => a.date.compareTo(b.date));
    DateTime? currentGroupDate;
    for (var document in documents) {

      DateTime date = document.date;
      if (currentGroupDate == null || currentGroupDate != date) {
        currentGroupDate = date;
        groupedList.add(HeaderItem(date));
      }
      groupedList.add(DocumentListItem(document));
      List<Payment> payments = await paymentUseCases.getByDocumentId(document.id!);
      for (var payment in payments){
        groupedList.add(PaymentListItem(payment));
      }
    }
    return groupedList;
  }

}