import 'package:good_manager/data/report_data/report_data.dart';

import '../../domain/entity/document.dart';
import '../../domain/entity/good.dart';
import '../../domain/usecase/documents/document_usecases.dart';
import '../../domain/usecase/goods/goods_usercases.dart';
import '../app_settings.dart';
import 'column_info.dart';
import 'outgoing_sales_loader.dart';
import 'sales_by_month_rows.dart';

class SalesByMonthReportData extends ReportData {
  /// The report covers the year of [start]; [end] is 31 Dec of that year.
  final DateTime start;
  final DateTime end;
  final DocumentUseCases documentUseCases;
  final DocumentType type;
  final GoodsUseCases goodsUseCases;

  SalesByMonthReportData({
    required this.start,
    required this.end,
    required this.documentUseCases,
    this.type = DocumentType.outgoing,
    required this.goodsUseCases,
  });

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("month"),
      ColumnInfo("quantity", showTotal: true),
      ColumnInfo("amount",
          showTotal: true, visibleWhen: ColumnGate.forDocumentType(type)),
      if (type == DocumentType.outgoing) ...[
        ColumnInfo("cost",
            showTotal: true, visibleWhen: ColumnGate.purchasePrice),
        ColumnInfo("profit",
            showTotal: true, visibleWhen: ColumnGate.bothPrices),
      ],
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    final List<Good> goods = await goodsUseCases
        .getAllByStoreId(AppSettings.getSelectedStoreId());
    final purchasePrices = <int, double?>{
      for (final good in goods)
        if (good.id != null) good.id!: good.purchasePrice,
    };
    final sales = await loadOutgoingSales(
      documentUseCases: documentUseCases,
      type: type,
      start: start,
      end: end,
    );
    return salesByMonthTableRows(
      buildSalesByMonthRows(
        type: type,
        year: start.year,
        documents: sales.documents,
        transactionsByDocumentId: sales.transactionsByDocumentId,
        purchasePriceByGoodId: purchasePrices,
      ),
      withCost: type == DocumentType.outgoing,
    );
  }
}
