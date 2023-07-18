/*import 'package:good_manager/domain/entities/document.dart';

class DocumentsData extends BaseData{
  final List<Document> items;
  final List<Document> incomingItems;
  final List<Document> outgoingItems;
  final bool showSearchBar;
  final String textSearch;
  final DocumentSettings settings;
  DocumentsData(super.state, this.items, this.incomingItems, this.outgoingItems, this.showSearchBar, this.textSearch, this.settings);

}*/
part of 'documents_cubit.dart';

@freezed
class DocumentsState with _$DocumentsState{
  const factory DocumentsState.initial({
    required BaseState state,
    @Default([]) List<Document> items,
    @Default([]) List<Document> incomingItems,
    @Default([]) List<Document> outgoingItems,
    @Default('') String textSearch,
    required DocumentsSetting settings,
    @Default(false) bool showSearchBar}) = _Initial;
}