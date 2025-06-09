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
part of 'select_document_cubit.dart';

@freezed
class SelectDocumentState with _$SelectDocumentState{
  const factory SelectDocumentState.initial({
    required BaseState state,
    required DocumentType type,
    @Default([]) List<Document> allDocuments,
    @Default([]) List<Document> documents,
    @Default([]) List<ListItem> items,
    @Default('') String textSearch,
    required DocumentsSetting settings,
    @Default(false) bool showSearchBar}) = _Initial;
}