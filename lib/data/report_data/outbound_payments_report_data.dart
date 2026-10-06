import 'package:easy_localization/easy_localization.dart';
import 'package:good_manager/data/report_data/column_info.dart';
import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';
import 'package:good_manager/domain/usecase/usecase.dart';

import '../../domain/entity/payment.dart';

class OutboundPaymentsReportData extends ReportData{
  final DateTime start;
  final DateTime end;
  final PaymentUseCases paymentUseCases;

  OutboundPaymentsReportData(
      {required this.start,
        required this.end,
        required this.paymentUseCases
      });


  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("label_category_name", isPickValues: true),
      ColumnInfo("amount", showTotal: true),
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    List<MapEntry<int, List<String>>> results = [];

    List<Payment> allItems = await paymentUseCases.getInRange(start, end);

    // Adjust filter if it's really inbound
    List<Payment> outboundItems =
    allItems.where((item) => item.type == PaymentType.outbound).toList();

    var items = [...outboundItems]..sort((a, b) {
      if (a.category?.name == null) return 1;
      if (b.category?.name == null) return -1;
      return a.category!.name.compareTo(b.category!.name);
    });

    // categoryId -> (categoryName, total)
    Map<int, MapEntry<String, double>> categoryTotals = {};

    for (Payment item in items) {
      final id = item.category?.id ?? -1; // -1 = no category
      final name = item.category?.name ?? "no_category".tr();

      final current = categoryTotals[id]?.value ?? 0.0;
      categoryTotals[id] = MapEntry(name, current + (item.amount ?? 0));
    }

    categoryTotals.forEach((id, entry) {
      results.add(MapEntry(id, [entry.key, getDoubleText(entry.value)]));
    });

    return results;
  }


}