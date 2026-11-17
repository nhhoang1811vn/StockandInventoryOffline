import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/barcode_scanner_settings/change_batch_mode_scan_dialog.dart';
import 'package:good_manager/presentation/pages/barcode_scanner_settings/change_batch_scan_delay_dialog.dart';

import '../../../domain/entity/entity.dart';
import '../../widget/widget.dart';
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
      builder: (context, state) => SettingsScaffold(
        title: context.tr("menu_item_barcode_scanner"),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            SettingsSectionHeader(context.tr("batch_mode_scan"), isFirst: true),
            SettingsMenuCard(
              children: [
                SettingsMenuItem(
                  icon: Icons.qr_code_scanner_rounded,
                  title: context.tr("after_each_scan"),
                  subtitle: state.batchModeScan == BatchModeScan.AUTO
                      ? context.tr("after_each_scan_auto")
                      : context.tr("after_each_scan_manually"),
                  onTap: () => showAfterEachScanDialog(context, state),
                  isLast: state.batchModeScan != BatchModeScan.AUTO,
                ),
                if (state.batchModeScan == BatchModeScan.AUTO)
                  SettingsMenuItem(
                    icon: Icons.timer_outlined,
                    title: context.tr("batch_scan_delay"),
                    subtitle: ChangeBatchScanDelayDialogWidget.format(
                        context, state.batchScanDelayMs),
                    onTap: () => showBatchScanDelayDialog(context, state),
                    isLast: true,
                  ),
              ],
            ),
            SettingsSectionHeader(context.tr("when_a_barcode_is_found")),
            SettingsMenuCard(
              children: [
                SettingsSwitchItem(
                  icon: Icons.volume_up_outlined,
                  title: context.tr("beep"),
                  value: state.enableBeep,
                  onChanged: (value) {
                    context
                        .read<BarcodeScannerSettingsCubit>()
                        .onEnableBeepChanged(value);
                  },
                ),
                SettingsSwitchItem(
                  icon: Icons.vibration_rounded,
                  title: context.tr("vibrate"),
                  value: state.enableVibrate,
                  onChanged: (value) {
                    context
                        .read<BarcodeScannerSettingsCubit>()
                        .onEnableVibrateChanged(value);
                  },
                  isLast: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showBatchScanDelayDialog(
    BuildContext context,
    BarcodeScannerSettingsState state,
  ) async {
    final newDelay = await showDialog<int>(
      context: context,
      builder: (_) => ChangeBatchScanDelayDialogWidget(state.batchScanDelayMs),
    );
    if (newDelay != null && context.mounted) {
      context.read<BarcodeScannerSettingsCubit>().setBatchScanDelayMs(newDelay);
    }
  }

  void showAfterEachScanDialog(
    BuildContext context,
    BarcodeScannerSettingsState state,
  ) async {
    final newMode = await showDialog(
      context: context,
      builder: (_) => ChangeBatchModeScanDialogWidget(state.batchModeScan),
      barrierDismissible: false,
    );
    if (newMode != null) {
      context.read<BarcodeScannerSettingsCubit>().setBatchModeScan(newMode);
    }
  }
}
