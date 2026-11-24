import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';
import 'package:good_manager/domain/usecase/suppliers/suppliers_usecases.dart';

import '../../domain/entity/document.dart';
import '../../domain/entity/supplier.dart';
import '../../domain/usecase/documents/document_usecases.dart';
import '../app_settings.dart';
import 'column_info.dart';

class DebtOfSupplierReportData extends ReportData {
  final DateTime start;
  final DateTime end;
  final SuppliersUseCase suppliersUseCase;
  final DocumentUseCases documentUseCases;

  DebtOfSupplierReportData(
      {required this.start,
      required this.end,
      required this.suppliersUseCase,
        required this.documentUseCases
      });

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("supplier", isPickValues: true),
      ColumnInfo("amount",
          showTotal: true, visibleWhen: ColumnGate.purchasePrice),
      ColumnInfo("paid", showTotal: true,),
      ColumnInfo("remaining", showTotal: true,),
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    List<MapEntry<int, List<String>>> results = [];
    int storeId = AppSettings.getSelectedStoreId();
    List<Supplier> suppliers = await suppliersUseCase.getAllByStoreId(storeId);
    List<Document> allDocuments =
        await documentUseCases.getInRange(start, end);
    List<Document> incomingDocuments = allDocuments
        .where((item) => item.type == DocumentType.incoming)
        .toList();
    for (Supplier supplier in suppliers) {
      String supplierName = supplier.name;
      List<Document> documents = incomingDocuments
          .where((item) => item.personId == supplier.id)
          .toList();

      double personTotalAmount = 0.0;
      double personTotalPaid = 0.0;
      double personTotalRemaining = 0.0;

      for (Document document in documents) {
        personTotalAmount += document.amount;
        personTotalPaid += document.paid;
        personTotalRemaining += (document.amount - document.paid);
      }

      results.add(MapEntry(supplier.id!, [
        supplierName,
        getDoubleText(personTotalAmount),
        getDoubleText(personTotalPaid),
        getDoubleText(personTotalRemaining),
      ]));
    }
    return results;
  }
}
