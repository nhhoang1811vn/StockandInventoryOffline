part of 'documents_cubit.dart';

@freezed
class DocumentsState with _$DocumentsState {
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
    Color? outgoingColor,
  }) = _Initial;
}
