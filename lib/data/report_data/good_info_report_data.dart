import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';

import '../../../data/app_settings.dart';
import '../../../domain/entity/good.dart';
import '../../../domain/entity/group.dart';
import '../../../domain/usecase/goods/goods_usercases.dart';
import '../../../domain/usecase/groups/groups_usecases.dart';
import 'column_info.dart';

class GoodInfoReportData extends ReportData {
  final GoodsUseCases goodsUseCases;
  final GroupsUseCases groupsUseCases;


  GoodInfoReportData(
      {
      required this.goodsUseCases,
      required this.groupsUseCases,
      });

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("name"),
      ColumnInfo("folder", isPickValues: true),
      ColumnInfo("barcode", visibleWhen: ColumnGate.barcode),
      ColumnInfo("purchase_price", visibleWhen: ColumnGate.purchasePrice),
      ColumnInfo("sale_price", visibleWhen: ColumnGate.salePrice),
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    int storeId = AppSettings.getSelectedStoreId();
    List<Good> allGoods = await goodsUseCases.getAllByStoreId(storeId);
    allGoods.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    List<MapEntry<int, List<String>>> results = [];
    for (Good good in allGoods) {
      var groupName = "No Group";
      if (good.groupId != null) {
        Group group = await groupsUseCases.getById(good.groupId!);
        groupName = group.name;
      }
      List<String> row = [
        good.name,
        groupName,
        good.barCode ?? "",
        getDoubleText(good.purchasePrice ?? 0.0),
        getDoubleText(good.salePrice ?? 0.0),
      ];
      results.add(MapEntry(good.id!, row));
    }
    return results;
  }
}
