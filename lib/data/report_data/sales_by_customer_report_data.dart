import 'package:easy_localization/easy_localization.dart';
import 'package:good_manager/data/report_data/report_data.dart';

import '../../domain/entity/good.dart';
import '../../domain/usecase/customers/customers_usecases.dart';
import '../../domain/usecase/documents/document_usecases.dart';
import '../../domain/usecase/goods/goods_usercases.dart';
import '../app_settings.dart';
import 'column_info.dart';
import 'outgoing_sales_loader.dart';
import 'sales_by_customer_rows.dart';

class SalesByCustomerReportData extends ReportData {
  final DateTime start;
  final DateTime end;

  /// null means all customers (plus a "No customer" row).
  final int? customerId;
  final DocumentUseCases documentUseCases;
  final CustomersUseCase customersUseCase;
  final GoodsUseCases goodsUseCases;

  SalesByCustomerReportData({
    required this.start,
    required this.end,
    required this.customerId,
    required this.documentUseCases,
    required this.customersUseCase,
    required this.goodsUseCases,
  });

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("customer"),
      ColumnInfo("quantity", showTotal: true),
      ColumnInfo("amount", showTotal: true),
      ColumnInfo("cost", showTotal: true),
      ColumnInfo("profit", showTotal: true),
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    int storeId = AppSettings.getSelectedStoreId();
    final customers = await customersUseCase.getAllByStoreId(storeId);
    final List<Good> goods = await goodsUseCases.getAllByStoreId(storeId);
    final purchasePrices = <int, double?>{
      for (final good in goods)
        if (good.id != null) good.id!: good.purchasePrice,
    };
    final sales = await loadOutgoingSales(
      documentUseCases: documentUseCases,
      start: start,
      end: end,
    );
    return salesByCustomerTableRows(
      buildSalesByCustomerRows(
        customers: customers,
        documents: sales.documents,
        transactionsByDocumentId: sales.transactionsByDocumentId,
        purchasePriceByGoodId: purchasePrices,
        onlyCustomerId: customerId,
      ),
      'no_customer'.tr(),
    );
  }
}
