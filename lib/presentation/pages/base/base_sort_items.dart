import 'package:good_manager/domain/entities/base_model.dart';

abstract class SortItems<T extends BaseModel> {
  int getResult(T item1, T item2);
}

class SortByNameAToZ<T extends BaseModel> extends SortItems<T> {
  @override
  int getResult(T item1, T item2) {
    return item1.name.compareTo(item2.name);
  }
}

class SortByNameZToA<T extends BaseModel> extends SortItems<T> {
  @override
  int getResult(T item1, T item2) {
    return item2.name.compareTo(item1.name);
  }
}

class SortByCreatedDate<T extends BaseModel> extends SortItems<T> {
  @override
  int getResult(T item1, T item2) {
    return item1.createdDate.compareTo(item2.createdDate);
  }
}
