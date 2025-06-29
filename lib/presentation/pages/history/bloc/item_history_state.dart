part of 'item_history_cubit.dart';
@freezed
class ItemHistoryState with _$ItemHistoryState{
  const factory ItemHistoryState.initial({
    required BaseState state,
    DateTime? start,
    DateTime? end,
    int? goodId,

    @Default(0) double startPeriodQuantity,
    @Default(0) double inQuantity,
    @Default(0) double outQuantity,
    @Default(0) double endPeriodQuantity,
  @Default([]) List<GoodHistory> goodHistories,
    @Default([]) List<ListItem> items,

    Color? incomingColor,
    Color? outgoingColor
    }) = _Initial;
}