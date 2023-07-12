/*
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/data/repositories/data_app_repository.dart';

import 'barcode_scanner_controller.dart';

class BarcodeScannerPage extends View {
  BarcodeScannerPage({Key key});

  @override
  BarcodeScannerPageView createState() => BarcodeScannerPageView();
}

class BarcodeScannerPageView
    extends ViewState<BarcodeScannerPage, BarcodeScannerController> {
  BarcodeScannerPageView()
      : super(BarcodeScannerController(DataAppRepository()));

  Widget get appBar => AppBar(
      title: new Text(
          AppLocalizations.of(context)!.menu_item_barcode_scanner_title));

  Widget getBody() {
    List<Widget> children = [
      ListTile(
        title: Text(AppLocalizations.of(context)!.batch_mode_scan),
        dense: true,
      ),
      batchModeScan,
      ListTile(
        title: Text(AppLocalizations.of(context)!.when_a_barcode_is_found),
        dense: true,
      ),
      beep,
      vibrate,
    ];
    return Column(children: children);
  }

  Widget get batchModeScan => ControlledWidgetBuilder<BarcodeScannerController>(
          builder: (context, controller) {
        return ListTile(
          title: Text(AppLocalizations.of(context)!.after_each_scan),
          subtitle: Text(controller.getBatchModeScanText()),
          onTap: controller.onChangeBatchModeScan,
        );
      });

  Widget get beep => ControlledWidgetBuilder<BarcodeScannerController>(
          builder: (context, controller) {
        return SwitchListTile(
          title: Text(AppLocalizations.of(context)!.beep),
          value: controller.settings.enableBeep,
          onChanged: (value) {
            controller.setEnableBeep(value);
          },
        );
      });

  Widget get vibrate => ControlledWidgetBuilder<BarcodeScannerController>(
          builder: (context, controller) {
        return SwitchListTile(
          title: Text(AppLocalizations.of(context)!.vibrate),
          value: controller.settings.enableVibrate,
          onChanged: (value) {
            controller.setEnableVibrate(value);
          },
        );
      });

  @override
  Widget get view => Scaffold(
        key: globalKey,
        appBar: appBar,
        body: getBody(),
      );
}
*/
