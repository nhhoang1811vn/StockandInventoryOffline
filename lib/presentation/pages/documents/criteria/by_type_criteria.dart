import 'package:good_manager/presentation/criteria/criteria.dart';

import '../../../../domain/entity/entity.dart';

class ByTypeCriteria extends Criteria<Document> {
  final DocumentType type;

  ByTypeCriteria(this.type);

  @override
  List<Document> meetCriteria(List<Document> input) {
    return input.where((document) => document.type == type).toList();
  }
}
