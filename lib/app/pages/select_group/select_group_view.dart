import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/select_group/select_group_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_group_repository.dart';
import 'package:good_manager/domain/entities/group.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SelectGroupPage extends View {
  final int groupId;

  SelectGroupPage(this.groupId) : super();

  @override
  SelectGroupPageView createState() => SelectGroupPageView(this.groupId);
}

class SelectGroupPageView
    extends ViewState<SelectGroupPage, SelectGroupController> {
  SelectGroupPageView(groupId)
      : super(SelectGroupController(DataGroupRepository(), groupId));

  @override
  Widget get view => Scaffold(
        key: globalKey,
        appBar: appBar,
        body: ControlledWidgetBuilder<SelectGroupController>(
            builder: (context, controller) {
          return ModalProgressHUD(
              child: listView, inAsyncCall: controller.isLoading, opacity: 0);
        }),
      );

  Widget get appBar => AppBar(
      title: new Text(AppLocalizations.of(context).select_group_title),
      actions: [save]);

  Widget get listView => ControlledWidgetBuilder<SelectGroupController>(
          builder: (context, controller) {
        return ListView.separated(
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                leading: Image.asset(
                  UIConstants.folderIconPath,
                  width: 24,
                ),
                title: Text(controller.items[index].name),
                subtitle: Text(controller.items[index].description),
                selected: index == controller.selectedIndex,
                onTap: () => controller.select(index),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: controller.items.length);
      });

  Widget get save => Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: ControlledWidgetBuilder<SelectGroupController>(
            builder: (context, controller) {
          return GestureDetector(
              onTap: controller.save, child: Icon(Icons.check, size: 26));
        }),
      );
}
