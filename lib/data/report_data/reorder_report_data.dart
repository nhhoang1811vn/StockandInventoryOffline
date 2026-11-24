import 'package:good_manager/data/report_data/column_info.dart';
import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';
import 'package:good_manager/domain/usecase/usecase.dart';

import '../../domain/entity/good.dart';
import '../app_settings.dart';

class ReorderReportData extends ReportData{
  final GoodsUseCases goodsUseCase;

  ReorderReportData(
      {
        required this.goodsUseCase
      });


  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("name"),
      ColumnInfo("barcode", visibleWhen: ColumnGate.barcode),
      ColumnInfo("quantity", showTotal: true, isQuantity: true),
      ColumnInfo("min_quantity", isQuantity: true),
      ColumnInfo("field_reorder", showTotal: true, isQuantity: true),
      ColumnInfo("purchase_price", visibleWhen: ColumnGate.purchasePrice),
      ColumnInfo("amount",
          showTotal: true, visibleWhen: ColumnGate.purchasePrice),
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    List<MapEntry<int, List<String>>> results = [];
    int storeId = AppSettings.getSelectedStoreId();
    List<Good> allGoods = await goodsUseCase.getAllByStoreId(storeId);
    allGoods
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    List<Good> items = [];
    for (Good good in allGoods) {
      var minQuan = 0.0;
      if (good.minQuantity != null) {
        minQuan = good.minQuantity!;
      }
      if (good.quantity < minQuan) {
        items.add(good);
      }
    }
    for (Good item in items) {
      var minQuan = 0.0;
      if (item.minQuantity != null) {
        minQuan = item.minQuantity!;
      }
      var reorder = minQuan - item.quantity;
      var amount = reorder * (item.purchasePrice ?? 0.0);
      List<String> row = [
        item.name,
        item.barCode ?? "",
        getQuantityTextForReport(item.quantity),
        getQuantityTextForReport(minQuan),
        getQuantityTextForReport(reorder),
        getDoubleText(item.purchasePrice ?? 0),
        getDoubleText(amount),
      ];
      results.add(MapEntry(item.id!, row));
    }
    return results;
  }


}