import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/select_store/select_store_controller.dart';
import 'package:good_manager/app/utils/constants.dart';
import 'package:good_manager/data/repositories/data_store_repository.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SelectStorePage extends View {
  final int storeId;

  SelectStorePage(this.storeId) : super();

  @override
  SelectStorePageView createState() => SelectStorePageView(this.storeId);
}

class SelectStorePageView
    extends ViewState<SelectStorePage, SelectStoreController> {
  SelectStorePageView(storeId)
      : super(SelectStoreController(DataStoreRepository(), storeId));

  @override
  Widget get view => Scaffold(
        key: globalKey,
        appBar: appBar,
        body: ControlledWidgetBuilder<SelectStoreController>(
            builder: (context, controller) {
          return ModalProgressHUD(
              child: listView, inAsyncCall: controller.isLoading, opacity: 0);
        }),
      );

  Widget get appBar => AppBar(
      title: new Text(AppLocalizations.of(context).select_store_title),
      actions: [save]);

  Widget get listView => ControlledWidgetBuilder<SelectStoreController>(
          builder: (context, controller) {
        return ListView.separated(
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                leading: Image.asset(
                  UIConstants.storeIconPath,
                  width: 24,
                ),
                title: Text(controller.items[index].name),
                subtitle: Text(controller.items[index].description),
                selected: controller.items[index].id == controller.storeId,
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
        child: ControlledWidgetBuilder<SelectStoreController>(
            builder: (context, controller) {
          return GestureDetector(
              onTap: controller.save, child: Icon(Icons.check, size: 26));
        }),
      );
}
