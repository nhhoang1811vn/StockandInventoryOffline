import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/documents/criteria/by_search_text_criteria.dart';

void main() {
  final doc = Document()
    ..name = 'INV-77'
    ..description = 'urgent delivery'
    ..personName = 'Alice'
    ..type = DocumentType.outgoing;

  List<Document> search(String text, [DocumentPropertiesSettings? p]) =>
      BySearchTextCriteria(text, properties: p).meetCriteria([doc]);

  test('matches number, description and person when all are shown', () {
    expect(search('inv-77'), isNotEmpty);
    expect(search('urgent'), isNotEmpty);
    expect(search('alice'), isNotEmpty);
  });

  test('does not match the Document no when it is hidden', () {
    final p = DocumentPropertiesSettings(showDocumentNo: false);
    expect(search('inv-77', p), isEmpty);
    expect(search('urgent', p), isNotEmpty);
  });

  test('does not match the description when it is hidden', () {
    final p = DocumentPropertiesSettings(showDescription: false);
    expect(search('urgent', p), isEmpty);
    expect(search('inv-77', p), isNotEmpty);
  });

  test('the person always matches', () {
    final p = DocumentPropertiesSettings(
        showDocumentNo: false, showDescription: false);
    expect(search('alice', p), isNotEmpty);
  });
}
