part of 'select_group_cubit.dart';

@freezed
class SelectGroupState with _$SelectGroupState {
  const factory SelectGroupState.initial({
    required BaseState state,
    int? selectedGroupId,
    String? selectedGroupName,
    Map<int, Group>? items,
    Map<int, dynamic>? treeMap,
  }) = _Initial;
}
