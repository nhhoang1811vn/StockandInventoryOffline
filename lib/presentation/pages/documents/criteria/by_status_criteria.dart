import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/document_paid_status.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';
import 'package:good_manager/presentation/utils.dart';

class ByStatusCriteria extends Criteria<Document>{
  final DocumentPaidStatus status;
  ByStatusCriteria(this.status);

  @override
  List<Document> meetCriteria(List<Document> input) {
    return input.where((document) => Utils.getStatus(document) == status).toList();
  }
}