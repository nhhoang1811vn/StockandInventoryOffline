import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/domain/usecase/usecase.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/app_settings.dart';
import '../../../../domain/entity/entity.dart';
import '../../base/base_state.dart';

part 'select_group_cubit.freezed.dart';
part 'select_group_state.dart';

@injectable
class SelectGroupCubit extends Cubit<SelectGroupState> {
  final GroupsUseCases groupsUseCase;

  SelectGroupCubit({required this.groupsUseCase})
      : super(SelectGroupState.initial(state: InitialState()));

  void select(Group? item) {
    emit(
      state.copyWith(selectedGroupId: item?.id, selectedGroupName: item?.name),
    );
  }

  void init(int? id, int? groupId) async {
    int storeId = AppSettings.getSelectedStoreId();
    List<Group> groups = await groupsUseCase.getAllByStoreId(storeId);
    if (isClosed) return;

    Map<int, Group> items = {};
    Group rootGroup = Group();
    rootGroup.name = "No Group";
    items[-1] = rootGroup;
    for (Group group in groups) {
      items[group.id!] = group;
    }
    if (id != null) {
      //moving group, remove itself from the list
      items.remove(id);
    }
    emit(state.copyWith(selectedGroupId: groupId, items: items));
    Map<int, dynamic> map = run(null);
    if (isClosed) return;
    emit(state.copyWith(treeMap: map));
  }

  Map<int, dynamic> run(int? groupId) {
    Map<int, dynamic> map = Map();
    state.items?.forEach((key, value) {
      if (value.groupId == groupId) {
        if (value.id == null) {
          map[-1] = null;
        } else {
          map[value.id!] = run(value.id);
        }
      }
    });
    return map;
  }
}
