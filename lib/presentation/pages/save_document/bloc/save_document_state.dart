part of 'save_document_cubit.dart';

@freezed
class SaveDocumentState with _$SaveDocumentState {
  const factory SaveDocumentState.initial({
    required BaseState state,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    DateTime? date,
    @Default('') String exceptionError,
    Document? item,
    int? personId,
    String? personName,
    required SaveDocumentSetting setting,
    @Default([]) List<DocumentTransaction> allTransactions,
    @Default([]) List<DocumentTransaction> transactions,
    @Default(false) bool showSearchBar,
    @Default('') String textSearch,
    @Default(0) double totalQuantity,
    @Default(0) double totalAmount,
    @Default([]) List<Payment> payments,
  }) = _Initial;
}
