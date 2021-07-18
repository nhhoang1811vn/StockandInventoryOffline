import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:good_manager/domain/usecases/groups/insert_group_usecase.dart';
import 'package:good_manager/domain/usecases/groups/update_group_usecase.dart';

import '../base_save_item_presenter.dart';

class SaveGroupPresenter extends BaseSaveItemPresenter<Group> {
  SaveGroupPresenter(repository) : super(repository);
}