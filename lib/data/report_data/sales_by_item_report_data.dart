import 'package:good_manager/data/report_data/report_data.dart';

import '../../domain/entity/document.dart';
import '../../domain/entity/good.dart';
import '../../domain/usecase/documents/document_usecases.dart';
import '../../domain/usecase/goods/goods_usercases.dart';
import '../app_settings.dart';
import 'column_info.dart';
import 'outgoing_sales_loader.dart';
import 'sales_by_item_rows.dart';

class SalesByItemReportData extends ReportData {
  final DateTime start;
  final DateTime end;

  /// null means all groups.
  final int? groupId;
  final DocumentUseCases documentUseCases;
  final DocumentType type;
  final GoodsUseCases goodsUseCases;

  SalesByItemReportData({
    required this.start,
    required this.end,
    required this.groupId,
    required this.documentUseCases,
    this.type = DocumentType.outgoing,
    required this.goodsUseCases,
  });

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("good_name"),
      ColumnInfo("quantity", showTotal: true, isQuantity: true),
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
    List<Good> goods = groupId == null
        ? await goodsUseCases.getAllByStoreId(AppSettings.getSelectedStoreId())
        : await goodsUseCases.getGoodsByGroupId(groupId);
    OutgoingSales sales = await loadOutgoingSales(
      documentUseCases: documentUseCases,
      type: type,
      start: start,
      end: end,
    );
    return salesByItemTableRows(
      buildSalesByItemRows(
        type: type,
        goods: goods,
        documents: sales.documents,
        transactionsByDocumentId: sales.transactionsByDocumentId,
      ),
      withCost: type == DocumentType.outgoing,
    );
  }
}
