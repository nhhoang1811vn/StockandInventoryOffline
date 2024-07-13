import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/batch_mode_scan.dart';
import 'package:good_manager/presentation/pages/barcode_scanner/bloc/barcode_scanner_cubit.dart';
import 'package:good_manager/presentation/pages/barcode_scanner/change_batch_mode_scan_dialog.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';

import '../../constants.dart';

class BarcodeScannerPage extends StatefulWidget {
  BarcodeScannerPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return BarcodeScannerPageState();
  }
}
class BarcodeScannerPageState extends BaseStateWidget<BarcodeScannerPage> {
  @override
  Widget buildWidget(BuildContext context) {
    return BlocConsumer<BarcodeScannerCubit, BarcodeScannerState>(
      listener: (context, state) async {

      },
      builder: (context, state) => Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, state),
    ));
  }
  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(UIConstants.appBarHeight),
      child: AppBar(title: new Text(AppLocalizations.of(context)!.menu_item_barcode_scanner_title)),
    );
  }

  Widget _buildBody(BuildContext context, BarcodeScannerState state) {
    List<Widget> children = [
      ListTile(
        textColor: UIConstants.primaryColor,
        title: Text(AppLocalizations.of(context)!.batch_mode_scan)
      ),
      _buildAfterEachScan(context, state),
      ListTile(
        textColor: UIConstants.primaryColor,
        title: Text(AppLocalizations.of(context)!.when_a_barcode_is_found)
      ),
      _buildBeep(context,state),
      _buildVibrate(context,state)
    ];
    return Column(children: children);
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
    /*BatchModeScan mode;
    if (state.batchModeScan == BatchModeScan.AUTO){
      mode = BatchModeScan.AUTO;
    }else{
      mode = BatchModeScan.MANUAL;
    }*/
    BatchModeScan newMode = await showDialog(
        context: context,
        builder: (_) => ChangeBatchModeScanDialogWidget(state.batchModeScan),
        barrierDismissible: true);

    context.read<BarcodeScannerCubit>().setBatchModeScan(newMode);
  }
}
