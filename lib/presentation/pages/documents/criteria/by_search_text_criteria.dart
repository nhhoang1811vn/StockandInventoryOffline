import 'package:good_manager/presentation/criteria/criteria.dart';

import '../../../../domain/entity/entity.dart';

class BySearchTextCriteria extends Criteria<Document> {
  final String textSearch;

  BySearchTextCriteria(this.textSearch);

  @override
  List<Document> meetCriteria(List<Document> input) {
    return input
        .where((document) => filterDocument(document, textSearch))
        .toList();
  }

  bool filterDocument(Document document, String textSearch) {
    final query = textSearch.toLowerCase();
    return (document.name.toLowerCase().contains(query) ||
        document.description.toLowerCase().contains(query) ||
        (document.personName != null &&
            document.personName!.toLowerCase().contains(query)));
  }
}
