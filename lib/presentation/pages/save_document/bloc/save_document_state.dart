part of 'save_document_cubit.dart';
@freezed
class SaveDocumentState with _$SaveDocumentState {
  const factory SaveDocumentState.initial({
    required BaseState state,
    @Default(-1) int id,
    @Default(NameInput.pure()) NameInput name,
    @Default('') String description,
    DateTime? date,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default('') String exceptionError,
    Document? item,
    Supplier? supplier,
    @Default([]) List<DocumentTransaction> transactions
  }) = _Initial;
}

