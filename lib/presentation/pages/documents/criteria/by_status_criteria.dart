import 'package:good_manager/presentation/criteria/criteria.dart';
import 'package:good_manager/presentation/utils.dart';

import '../../../../domain/entity/entity.dart';

class ByStatusCriteria extends Criteria<Document> {
  final DocumentPaidStatus status;

  ByStatusCriteria(this.status);

  @override
  List<Document> meetCriteria(List<Document> input) {
    return input
        .where((document) => Utils.getStatus(document) == status)
        .toList();
  }
}
