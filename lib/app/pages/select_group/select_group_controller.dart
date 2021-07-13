import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/app/pages/select_group/select_group_presenter.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/domain/entities/group.dart';

class SelectGroupController extends Controller {
  bool isLoading = false;
  SelectGroupPresenter presenter;
  List<Group> items = [];
  int groupId;

  SelectGroupController(repository, this.groupId)
      : presenter = SelectGroupPresenter(repository),
        super() {
    isLoading = true;
    items = [];
    presenter.getGroups();
  }

  @override
  void initListeners() {
    presenter.getGroupsOnNext = (groups) {
      Group noGroup = Group();
      noGroup.id = -1;
      noGroup.name = "No Group";
      items.add(noGroup);
      items.addAll(groups);
      isLoading = false;
      refreshUI();
    };
    presenter.getGroupsOnError = (e) {
      showErrorToast(e.toString());
      isLoading = false;
      refreshUI();
    };
  }

  void save() {
    Navigator.of(getContext()).pop(groupId);
  }

  void select(int index) {
    groupId = items[index].id;
    refreshUI();
  }
}
