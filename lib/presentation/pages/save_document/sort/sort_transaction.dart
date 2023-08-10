import 'package:good_manager/domain/entities/transaction.dart';

abstract class SortTransaction{
  int getResult(DocumentTransaction transaction, DocumentTransaction transaction2);
}