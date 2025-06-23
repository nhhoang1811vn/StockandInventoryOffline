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
    @Default([]) List<Document> allDocuments,
    @Default([]) List<Document> documents,
    @Default([]) List<Document> incomingDocuments,
    @Default([]) List<Document> outgoingDocuments,
    @Default('') String textSearch,
    DocumentsSetting? setting,
    @Default(false) bool showSearchBar,
    Color? incomingColor,
    Color? outgoingColor
  }) = _Initial;
}