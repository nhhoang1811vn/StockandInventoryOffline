part of 'quick_insert_document_cubit.dart';

@freezed
class QuickInsertDocumentState with _$QuickInsertDocumentState {
  const factory QuickInsertDocumentState.initial({
    required BaseState state,
    double? quantity,
    double? price,
    double? amount,
    DateTime? date,
    int? personId,
    String? personName,
    @Default('') String description,
  }) = _Initial;
}