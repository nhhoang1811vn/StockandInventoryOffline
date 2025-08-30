import '../../../../domain/entity/entity.dart';

abstract class SortTransaction {
  int getResult(
    DocumentTransaction transaction,
    DocumentTransaction transaction2,
  );
}
