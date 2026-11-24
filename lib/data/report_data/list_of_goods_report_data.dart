import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';
import 'package:good_manager/util/extension/date_time_ext.dart';

import '../../../data/app_settings.dart';
import '../../../domain/entity/document.dart';
import '../../../domain/entity/good.dart';
import '../../../domain/entity/group.dart';
import '../../../domain/usecase/documents/document_usecases.dart';
import '../../../domain/usecase/goods/goods_usercases.dart';
import '../../../domain/usecase/groups/groups_usecases.dart';
import '../../../repo/document_transactions_repository.dart';
import 'column_info.dart';

class ListOfGoodsReportData extends ReportData {
  final DateTime start;
  final DateTime end;
  final GoodsUseCases goodsUseCases;
  final GroupsUseCases groupsUseCases;
  final DocumentUseCases documentUseCases;
  final DocumentTransactionRepository documentTransactionRepository;

  ListOfGoodsReportData(
      {required this.start,
      required this.end,
      required this.goodsUseCases,
      required this.groupsUseCases,
      required this.documentUseCases,
      required this.documentTransactionRepository});

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("name"),
      ColumnInfo(
        "folder",
        isPickValues: true,
      ),
      ColumnInfo("barcode", visibleWhen: ColumnGate.barcode),
      ColumnInfo(
        "field_start_period",
        showTotal: true,
      ),
      ColumnInfo("field_in", showTotal: true),
      ColumnInfo(
        "field_out",
        showTotal: true,
      ),
      ColumnInfo(
        "field_end_period",
        showTotal: true,
      )
    ];
  }

  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    int storeId = AppSettings.getSelectedStoreId();
    List<Good> allGoods = await goodsUseCases.getAllByStoreId(storeId);
    allGoods
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    List<Document> documentsPrePeriod = await documentUseCases.getInRange(
      DateTime.fromMillisecondsSinceEpoch(0),
      start.endOfYesterday(),
    );

    List<Document> documentsInPeriod = await documentUseCases.getInRange(
      start.startOfDay(),
      end.endOfDay(),
    );
    List<MapEntry<int, List<String>>> results = [];
    for (Good good in allGoods) {
      var groupName = "No Group";
      if (good.groupId != null) {
        Group group = await groupsUseCases.getById(good.groupId!);
        groupName = group.name;
      }
      double sumQuantityIncomingPre = await getSumQuantity(
          documentsPrePeriod, DocumentType.incoming, good.id!);
      double sumQuantityOutgoingPre = await getSumQuantity(
          documentsPrePeriod, DocumentType.outgoing, good.id!);
      double startPeriodStock = sumQuantityIncomingPre - sumQuantityOutgoingPre;

      double incoming = await getSumQuantity(
          documentsInPeriod, DocumentType.incoming, good.id!);
      double outgoing = await getSumQuantity(
        documentsInPeriod,
        DocumentType.outgoing,
        good.id!,
      );

      double endPeriodStock = startPeriodStock + incoming - outgoing;
      List<String> row = [
        good.name,
        groupName,
        good.barCode ?? "",
        getDoubleText(startPeriodStock),
        getDoubleText(incoming),
        getDoubleText(outgoing),
        getDoubleText(endPeriodStock),
      ];
      results.add(MapEntry(good.id!, row));
    }
    return results;
  }

  Future<double> getSumQuantity(
    List<Document> documents,
    DocumentType type,
    int goodId,
  ) async {
    double total = 0.0;
    for (Document document in documents) {
      total += await documentTransactionRepository
          .getSumQuantityByGoodIdAndByDocumentId(
        type,
        goodId,
        document.id!,
      );
    }
    return total;
  }
}
