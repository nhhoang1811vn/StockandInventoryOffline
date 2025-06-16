part of 'documents_history_cubit.dart';
@freezed
class DocumentsHistoryState with _$DocumentsHistoryState{
  const factory DocumentsHistoryState.initial({
    required BaseState state,
    DateTime? start,
    DateTime? end,
    int? supplierId,
    int? customerId,

  @Default([]) List<GoodHistory> goodHistories,
    @Default([]) List<ListItem> items
    }) = _Initial;
}