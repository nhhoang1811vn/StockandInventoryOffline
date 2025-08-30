import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';

import '../../../domain/entity/entity.dart';

class ChangeBatchModeScanDialogWidget extends StatefulWidget {
  final BatchModeScan mode;

  ChangeBatchModeScanDialogWidget(this.mode);

  @override
  State createState() => ChangeBatchModeScanDialogWidgetState();
}

class ChangeBatchModeScanDialogWidgetState
    extends State<ChangeBatchModeScanDialogWidget> {
  late BatchModeScan _mode;

  @override
  void initState() {
    _mode = widget.mode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.after_each_scan),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              children: [
                getRadioListTile(
                  AppLocalizations.of(context)!.after_each_scan_auto,
                  BatchModeScan.AUTO,
                ),
                getRadioListTile(
                  AppLocalizations.of(context)!.after_each_scan_manually,
                  BatchModeScan.MANUAL,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.action_ok),
          onPressed: () async {
            //widget.onValueChange(_mode);
            Navigator.of(context).pop(_mode);
          },
        ),
      ],
    );
  }

  RadioListTile<BatchModeScan> getRadioListTile(
    String text,
    BatchModeScan value,
  ) {
    return RadioListTile<BatchModeScan>(
      title: Text(text),
      value: value,
      groupValue: _mode,
      onChanged: (BatchModeScan? value) {
        setState(() {
          _mode = value!;
        });
      },
    );
  }
}
