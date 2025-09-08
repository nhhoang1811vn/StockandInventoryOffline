import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/barcode_scanner_settings/change_batch_mode_scan_dialog.dart';
import 'package:good_manager/presentation/widget/views.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import 'bloc/barcode_scanner_settings_cubit.dart';

class BarcodeScannerSettingsPage extends StatefulWidget {
  BarcodeScannerSettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BarcodeScannerSettingsPageState();
  }
}

class BarcodeScannerSettingsPageState
    extends State<BarcodeScannerSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BarcodeScannerSettingsCubit,
        BarcodeScannerSettingsState>(
      listener: (context, state) async {},
      builder: (context, state) => Scaffold(
        appBar: _buildAppBar(context),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              context.tr("batch_mode_scan"),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Card(
              child: Column(
                children: [
                  _buildAfterEachScan(context, state),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              context.tr("when_a_barcode_is_found"),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Card(
              child: Column(
                children: [
                  _buildBeep(context, state),
                  buildDivider(),
                  _buildVibrate(context, state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(
        title: new Text(
          context.tr("menu_item_barcode_scanner"),
        ),
      ),
    );
  }

  Widget _buildAfterEachScan(
    BuildContext context,
    BarcodeScannerSettingsState state,
  ) {
    return ListTile(
      title: Text(context.tr("after_each_scan")),
      subtitle: state.batchModeScan == BatchModeScan.AUTO
          ? Text(context.tr("after_each_scan_auto"))
          : Text(context.tr("after_each_scan_manually")),
      onTap: () => showAfterEachScanDialog(context, state),
    );
  }

  Widget _buildBeep(BuildContext context, BarcodeScannerSettingsState state) {
    return SwitchListTile(
      title: Text(context.tr("beep")),
      value: state.enableBeep,
      onChanged: (value) {
        context.read<BarcodeScannerSettingsCubit>().onEnableBeepChanged(value);
      },
    );
  }

  Widget _buildVibrate(
    BuildContext context,
    BarcodeScannerSettingsState state,
  ) {
    return SwitchListTile(
      title: Text(context.tr("vibrate")),
      value: state.enableVibrate,
      onChanged: (value) {
        context
            .read<BarcodeScannerSettingsCubit>()
            .onEnableVibrateChanged(value);
        //controller.setEnableVibrate(value);
      },
    );
  }

  void showAfterEachScanDialog(
    BuildContext context,
    BarcodeScannerSettingsState state,
  ) async {
    BatchModeScan? newMode = await showDialog(
      context: context,
      builder: (_) => ChangeBatchModeScanDialogWidget(state.batchModeScan),
      barrierDismissible: false,
    );
    if (newMode != null)
      context.read<BarcodeScannerSettingsCubit>().setBatchModeScan(newMode);
  }
}
