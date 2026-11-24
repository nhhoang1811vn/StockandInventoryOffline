import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/save_document/document_table_builder.dart';

void main() {
  String tr(String k) => k;
  String fmt(DateTime d) => 'D';

  List<MapEntry<String, String>> info(DocumentPropertiesSettings p) =>
      buildDocumentInfo(
        name: 'No 1',
        date: DateTime(2026, 1, 1),
        personName: 'Bob',
        description: 'note',
        properties: p,
        tr: tr,
        formatDate: fmt,
      );

  test('all shown lists number, date, person and description in order', () {
    expect(
        info(DocumentPropertiesSettings()).map((e) => '${e.key}=${e.value}'), [
      'document_name_no=No 1',
      'field_date_time=D',
      'person_name=Bob',
      'label_description=note',
    ]);
  });

  test('hidden properties are left out, the person stays', () {
    final keys = info(DocumentPropertiesSettings(
      showDocumentNo: false,
      showDateTime: false,
      showDescription: false,
    )).map((e) => e.key);
    expect(keys, ['person_name']);
  });

  test('only the hidden one is removed', () {
    final keys =
        info(DocumentPropertiesSettings(showDateTime: false)).map((e) => e.key);
    expect(keys, ['document_name_no', 'person_name', 'label_description']);
  });
}
