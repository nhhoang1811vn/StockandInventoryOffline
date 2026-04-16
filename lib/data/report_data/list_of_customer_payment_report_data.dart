import 'package:good_manager/data/report_data/column_info.dart';
import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';
import 'package:good_manager/domain/usecase/usecase.dart';

import '../../domain/entity/customer.dart';
import '../../domain/entity/payment.dart';
import '../app_settings.dart';

class ListOfCustomerPaymentReportData extends ReportData{
  final DateTime start;
  final DateTime end;
  final CustomersUseCase customersUseCase;
  final PaymentUseCases paymentUseCases;


  ListOfCustomerPaymentReportData(
      {
        required this.start,
        required this.end,
        required this.customersUseCase,
        required this.paymentUseCases,
      });
  @override
  List<ColumnInfo> getColumnInfos() {
    return [
       ColumnInfo("label_customer_name"),
       ColumnInfo("amount", showTotal: true),
    ];
  }
  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    List<MapEntry<int, List<String>>> results = [];
    int storeId = AppSettings.getSelectedStoreId();
    List<Customer> customers = await customersUseCase.getAllByStoreId(storeId);
    for (Customer customer in customers) {
      List<Payment> payments = await paymentUseCases.getInRangeByCustomerId(
        customer.id!,
        start,
        end,
      );
      results.add(MapEntry(customer.id!, [customer.name,getDoubleText(getTotal(payments))]));
    }
    return results;
  }


}