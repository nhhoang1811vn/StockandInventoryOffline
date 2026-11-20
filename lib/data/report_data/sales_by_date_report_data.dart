import 'package:good_manager/data/report_data/report_data.dart';

import '../../constant/date_format_factory.dart';
import '../../domain/entity/good.dart';
import '../../domain/usecase/documents/document_usecases.dart';
import '../../domain/usecase/goods/goods_usercases.dart';
import '../app_settings.dart';
import 'column_info.dart';
import 'outgoing_sales_loader.dart';
import 'sales_by_date_rows.dart';

class SalesByDateReportData extends ReportData {
  final DateTime start;
  final DateTime end;
  final DocumentUseCases documentUseCases;
  final GoodsUseCases goodsUseCases;

  SalesByDateReportData({
    required this.start,
    required this.end,
    required this.documentUseCases,
    required this.goodsUseCases,
  });

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("date"),
      ColumnInfo("quantity", showTotal: true),
      ColumnInfo("amount", showTotal: true),
      ColumnInfo("cost", showTotal: true),
      ColumnInfo("profit", showTotal: true),
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    OutgoingSales sales = await loadOutgoingSales(
      documentUseCases: documentUseCases,
      start: start,
      end: end,
    );
    List<Good> goods = await goodsUseCases
        .getAllByStoreId(AppSettings.getSelectedStoreId());
    Map<int, double?> purchasePrices = {
      for (Good good in goods)
        if (good.id != null) good.id!: good.purchasePrice,
    };
    return salesByDateTableRows(
      buildSalesByDateRows(
        start: start,
        end: end,
        documents: sales.documents,
        transactionsByDocumentId: sales.transactionsByDocumentId,
        purchasePriceByGoodId: purchasePrices,
      ),
      (day) => DateFormatFactory.getDateFormat().format(day),
    );
  }
}
