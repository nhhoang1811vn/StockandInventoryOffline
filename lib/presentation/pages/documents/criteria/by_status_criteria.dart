import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/presentation/criteria/criteria.dart';

class ByStatusCriteria extends Criteria<Document>{
  final bool isPaid;
  ByStatusCriteria(this.isPaid);

  @override
  List<Document> meetCriteria(List<Document> input) {
    if (isPaid){
      return input.where((document) => document.paid >= document.amount).toList();
    }else{
      return input.where((document) => document.paid < document.amount).toList();
    }
  }
}