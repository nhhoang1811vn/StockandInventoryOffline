import 'package:good_manager/data/report_data/column_info.dart';
import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/domain/usecase/usecase.dart';

import '../app_settings.dart';

class ListOfSupplierPaymentReportData extends ReportData{
  final DateTime start;
  final DateTime end;
  final SuppliersUseCase suppliersUseCase;
  final PaymentUseCases paymentUseCases;


  ListOfSupplierPaymentReportData(
      {
        required this.start,
        required this.end,
        required this.suppliersUseCase,
        required this.paymentUseCases,
      });
  @override
  List<ColumnInfo> getColumnInfos() {
    return [
       ColumnInfo("label_supplier_name"),
       ColumnInfo("amount", showTotal: true),
    ];
  }
  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    List<MapEntry<int, List<String>>> results = [];
    int storeId = AppSettings.getSelectedStoreId();
    List<Supplier> suppliers = await suppliersUseCase.getAllByStoreId(storeId);
    for (Supplier supplier in suppliers) {
      List<Payment> payments = await paymentUseCases.getInRangeBySupplierId(
        supplier.id!,
        start,
        end,
      );
      results.add(MapEntry(supplier.id!, [supplier.name,getDoubleText(getTotal(payments))]));
    }
    return results;
  }
}