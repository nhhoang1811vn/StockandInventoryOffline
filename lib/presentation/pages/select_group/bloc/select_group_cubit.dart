import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:good_manager/app/main.dart';
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

  void onSaveClicked(){

  }

  select(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void init(int groupId) async{
    int storeId = storage.getSelectedStoreId();
    List<Group> items = [];
    Group emptyGroup = Group();
    emptyGroup.name = "No Group";
    items.add(emptyGroup);

    List<Group> groups = await groupsUseCase.getAllByStoreId(storeId);
    items.addAll(groups);

    int selectedIndex = items.indexWhere((element) => element.id == groupId);
    emit(state.copyWith(selectedIndex: selectedIndex, items: items));
  }
}