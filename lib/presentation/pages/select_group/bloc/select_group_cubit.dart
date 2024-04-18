import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/main.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/group.dart';
import '../../../../domain/usecases/groups/groups_usecases.dart';
import '../../base/base_state.dart';

part 'select_group_cubit.freezed.dart';
part 'select_group_state.dart';

@injectable
class SelectGroupCubit extends Cubit<SelectGroupState> {
  final GroupsUseCases groupsUseCase;

  SelectGroupCubit({
    required this.groupsUseCase
  }) : super(SelectGroupState.initial(state: InitialState()));

  select(int? id) {
    emit(state.copyWith(selectedGroupId: id));
  }

  void init(int? id,int? groupId) async{
    int storeId = storage.getSelectedStoreId();
    List<Group> groups = await groupsUseCase.getAllByStoreId(storeId);
    Map<int, Group> items = {};
    Group rootGroup = Group();
    rootGroup.name = "No Group";
    items[-1] = rootGroup;
    for (Group group in groups){
      items[group.id!] = group;
    }
    if (id != null){
      //moving group, remove itself from the list
      items.remove(id);
    }
    emit(state.copyWith(selectedGroupId: groupId,items: items));
    Map<int,dynamic> map = run(null);
    emit(state.copyWith(treeMap: map));
  }
  Map<int,dynamic> run(int? groupId){
    Map<int,dynamic> map = Map();
    state.items?.forEach((key, value) {
      if (value.groupId == groupId){
        if (value.id == null){
          map[-1] = null;
        }else{
          map[value.id!] = run(value.id);
        }
      }
    });
    return map;
  }
}