part of 'item_history_cubit.dart';



@freezed
class ItemHistoryState with _$ItemHistoryState{
  const factory ItemHistoryState.initial({
    required BaseState state,
    DateTime? start,
    DateTime? end,
    int? goodId,
    @Default([]) List<GoodHistory> items
    }) = _Initial;
}