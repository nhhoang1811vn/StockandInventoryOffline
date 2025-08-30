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
    return (document.name.contains(textSearch) ||
        document.description.contains(textSearch) ||
        (document.personName != null &&
            document.personName!.contains(textSearch)));
  }
}
