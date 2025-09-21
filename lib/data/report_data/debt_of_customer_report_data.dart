import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';
import 'package:good_manager/domain/usecase/customers/customers_usecases.dart';

import '../../domain/entity/customer.dart';
import '../../domain/entity/document.dart';
import '../../domain/usecase/documents/document_usecases.dart';
import '../app_settings.dart';
import 'column_info.dart';

class DebtOfCustomerReportData extends ReportData {
  final DateTime start;
  final DateTime end;
  final CustomersUseCase customersUseCase;
  final DocumentUseCases documentUseCases;

  DebtOfCustomerReportData(
      {required this.start,
      required this.end,
      required this.customersUseCase,
        required this.documentUseCases
      });

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("customer", isPickValues: true),
      ColumnInfo("amount", showTotal: true,),
      ColumnInfo("paid", showTotal: true,),
      ColumnInfo("remaining", showTotal: true,),
    ];
  }
  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    List<MapEntry<int, List<String>>> results = [];
    int storeId = AppSettings.getSelectedStoreId();
    List<Customer> customers = await customersUseCase.getAllByStoreId(storeId);
    List<Document> allDocuments =
        await documentUseCases.getInRange(start, end);
    List<Document> outgoingDocuments = allDocuments
        .where((item) => item.type == DocumentType.outgoing)
        .toList();
    for (Customer customer in customers) {
      String customerName = customer.name;
      List<Document> documents = outgoingDocuments
          .where((item) => item.personId == customer.id)
          .toList();
      double personTotalAmount = 0.0;
      double personTotalPaid = 0.0;
      double personTotalRemaining = 0.0;

      for (Document document in documents) {
        personTotalAmount += document.amount;
        personTotalPaid += document.paid;
        personTotalRemaining += (document.amount - document.paid);
      }
      results.add(MapEntry(customer.id!, [
        customerName,
        getDoubleText(personTotalAmount),
        getDoubleText(personTotalPaid),
        getDoubleText(personTotalRemaining),
      ]));
    }
    return results;
  }
}
