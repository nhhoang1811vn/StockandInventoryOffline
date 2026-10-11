import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
      title: Text(context.tr("after_each_scan")),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            RadioGroup<BatchModeScan>(
              groupValue: _mode,
              onChanged: (BatchModeScan? value) {
                if (value == null) return;
                setState(() {
                  _mode = value;
                });
              },
              child: Column(
                children: [
                  getRadioListTile(
                    context.tr("after_each_scan_auto"),
                    BatchModeScan.AUTO,
                  ),
                  getRadioListTile(
                    context.tr("after_each_scan_manually"),
                    BatchModeScan.MANUAL,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(context.tr("ok")),
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
    );
  }
}
