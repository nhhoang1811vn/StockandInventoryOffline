import 'package:good_manager/data/report_data/report_data.dart';
import 'package:good_manager/data/report_data/utils.dart';

import '../../constant/date_format_factory.dart';
import '../../domain/entity/document.dart';
import '../../domain/usecase/documents/document_usecases.dart';
import 'column_info.dart';

class ListOfDocumentsReportData extends ReportData {
  final DateTime start;
  final DateTime end;
  final DocumentUseCases documentUseCases;


  ListOfDocumentsReportData(
      {required this.start,
      required this.end,
      required this.documentUseCases,
      });

  @override
  List<ColumnInfo> getColumnInfos() {
    return [
      ColumnInfo("date", documentVisibleWhen: DocumentColumnGate.dateTime),
      ColumnInfo("name", documentVisibleWhen: DocumentColumnGate.documentNo),
      ColumnInfo("type", isPickValues: true),
      ColumnInfo("person_name", isPickValues: true),
      ColumnInfo("quantity", showTotal: true),
      ColumnInfo("amount",
          showTotal: true, visibleWhen: ColumnGate.documentAmount),
    ];
  }
  @override
  Future<List<MapEntry<int, List<String>>>> getData() async {
    List<MapEntry<int, List<String>>> results = [];
    List<Document> items =
        await documentUseCases.getInRange(start, end);
    for (Document item in items) {
      List<String> row = [];
      row.add(DateFormatFactory.getDateFormat().format(item.date));
      row.add(item.name);
      if (item.type == DocumentType.incoming){
        row.add("Incoming");
      }else{
        row.add("Outgoing");
      }
      //row.add(item.type.getTitle(localizations));
      row.add(item.personName ?? '');
      row.add(getDoubleText(item.quantity));
      row.add(getDoubleText(item.amount));
      results.add(MapEntry(item.id!, row));
    }
    return results;
  }
}
