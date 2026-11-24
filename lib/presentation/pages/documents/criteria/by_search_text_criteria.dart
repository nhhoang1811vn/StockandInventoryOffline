import 'package:good_manager/presentation/criteria/criteria.dart';

import '../../../../domain/entity/entity.dart';

class BySearchTextCriteria extends Criteria<Document> {
  final String textSearch;

  /// Fields the Store hides are not matched, so a result never matches for a
  /// reason the user cannot see. Everything is searched when `null`.
  final DocumentPropertiesSettings properties;

  BySearchTextCriteria(this.textSearch,
      {DocumentPropertiesSettings? properties})
      : properties = properties ?? DocumentPropertiesSettings();

  @override
  List<Document> meetCriteria(List<Document> input) {
    return input
        .where((document) => filterDocument(document, textSearch))
        .toList();
  }

  bool filterDocument(Document document, String textSearch) {
    final query = textSearch.toLowerCase();
    return ((properties.showDocumentNo &&
            document.name.toLowerCase().contains(query)) ||
        (properties.showDescription &&
            document.description.toLowerCase().contains(query)) ||
        (document.personName != null &&
            document.personName!.toLowerCase().contains(query)));
  }
}
