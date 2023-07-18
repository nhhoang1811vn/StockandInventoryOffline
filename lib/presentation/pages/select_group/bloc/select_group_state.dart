part of 'select_group_cubit.dart';
@freezed
class SelectGroupState with _$SelectGroupState {
  const factory SelectGroupState.initial({
    required BaseState state,
    @Default(0) int selectedIndex,
    @Default([]) List<Group> items
  }) = _Initial;
}