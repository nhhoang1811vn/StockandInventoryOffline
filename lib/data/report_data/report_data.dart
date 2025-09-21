import 'column_info.dart';

abstract class ReportData {
  List<ColumnInfo> getColumnInfos();
  Future<List<MapEntry<int, List<String>>>> getData();
}