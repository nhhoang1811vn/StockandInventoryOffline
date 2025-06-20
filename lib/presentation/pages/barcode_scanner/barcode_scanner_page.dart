import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/domain/entities/batch_mode_scan.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/barcode_scanner/bloc/barcode_scanner_cubit.dart';
import 'package:good_manager/presentation/pages/barcode_scanner/change_batch_mode_scan_dialog.dart';

import '../../constants.dart';

class BarcodeScannerPage extends StatefulWidget {
  BarcodeScannerPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return BarcodeScannerPageState();
  }
}
class BarcodeScannerPageState extends State<BarcodeScannerPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BarcodeScannerCubit, BarcodeScannerState>(
      listener: (context, state) async {

      },
      builder: (context, state) => Scaffold(
      appBar: _buildAppBar(context),
      body:  ListView(children: [
        Card(margin: EdgeInsets.all(16), child: Column(
          children: [
            ListTile(
                textColor: Theme.of(context).colorScheme.primary,
                title: Text(AppLocalizations.of(context)!.batch_mode_scan)
            ),
            _buildAfterEachScan(context, state),
            ListTile(
                textColor: Theme.of(context).colorScheme.primary,
                title: Text(AppLocalizations.of(context)!.when_a_barcode_is_found)
            ),
            _buildBeep(context,state),
            _buildVibrate(context,state)
          ],
        ),),
      ]),
    ));
  }
  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(title: new Text(AppLocalizations.of(context)!.menu_item_barcode_scanner)),
    );
  }
  Widget _buildAfterEachScan(BuildContext context, BarcodeScannerState state){
    return ListTile(
      title: Text(AppLocalizations.of(context)!.after_each_scan),
      subtitle: state.batchModeScan == BatchModeScan.AUTO ? Text(AppLocalizations.of(context)!.after_each_scan_auto) : Text(AppLocalizations.of(context)!.after_each_scan_manually),
      onTap: () => showAfterEachScanDialog(context, state),
    );
  }
  Widget _buildBeep(BuildContext context,BarcodeScannerState state){
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.beep),
      value: state.enableBeep,
      onChanged: (value) {
        context.read<BarcodeScannerCubit>().onEnableBeepChanged(value);
      },
    );
  }
  Widget _buildVibrate(BuildContext context, BarcodeScannerState state){
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.vibrate),
      value: state.enableVibrate,
      onChanged: (value) {
        context.read<BarcodeScannerCubit>().onEnableVibrateChanged(value);
        //controller.setEnableVibrate(value);
      },
    );
  }
  void showAfterEachScanDialog(BuildContext context, BarcodeScannerState state) async{
    BatchModeScan? newMode = await showDialog(
        context: context,
        builder: (_) => ChangeBatchModeScanDialogWidget(state.batchModeScan),
        barrierDismissible: false);
    if (newMode != null)
      context.read<BarcodeScannerCubit>().setBatchModeScan(newMode);
  }
}
