import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/domain/entities/barcode_scanner_settings.dart';

class ChangeBatchModeScanDialogWidget extends StatefulWidget {
  final BatchModeScan mode;
  final void Function(BatchModeScan type) onValueChange;

  ChangeBatchModeScanDialogWidget(this.mode, this.onValueChange, {Key key})
      : super(key: key);

  @override
  State createState() => ChangeBatchModeScanDialogWidgetState();
}

class ChangeBatchModeScanDialogWidgetState
    extends State<ChangeBatchModeScanDialogWidget> {
  BatchModeScan _mode;

  @override
  void initState() {
    _mode = widget.mode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).after_each_scan),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Column(
              children: [
                getRadioListTile(
                    AppLocalizations.of(context).after_each_scan_auto,
                    BatchModeScan.AUTO),
                getRadioListTile(
                    AppLocalizations.of(context).after_each_scan_manually,
                    BatchModeScan.MANUALLY),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context).action_ok),
          onPressed: () async {
            widget.onValueChange(_mode);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  RadioListTile<BatchModeScan> getRadioListTile(
      String text, BatchModeScan value) {
    return RadioListTile<BatchModeScan>(
      title: Text(text),
      value: value,
      groupValue: _mode,
      onChanged: (BatchModeScan value) {
        setState(() {
          _mode = value;
        });
      },
    );
  }
}
