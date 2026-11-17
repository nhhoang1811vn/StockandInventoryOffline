import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeBatchScanDelayDialogWidget extends StatefulWidget {
  static const int minMs = 500;
  static const int maxMs = 10000;
  static const int stepMs = 500;

  final int delayMs;

  const ChangeBatchScanDelayDialogWidget(this.delayMs, {Key? key})
      : super(key: key);

  static String format(BuildContext context, int ms) =>
      context.tr("batch_scan_delay_value", args: [(ms / 1000).toString()]);

  @override
  State createState() => ChangeBatchScanDelayDialogWidgetState();
}

class ChangeBatchScanDelayDialogWidgetState
    extends State<ChangeBatchScanDelayDialogWidget> {
  late int _delayMs;

  @override
  void initState() {
    _delayMs = widget.delayMs.clamp(
      ChangeBatchScanDelayDialogWidget.minMs,
      ChangeBatchScanDelayDialogWidget.maxMs,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const min = ChangeBatchScanDelayDialogWidget.minMs;
    const max = ChangeBatchScanDelayDialogWidget.maxMs;
    const step = ChangeBatchScanDelayDialogWidget.stepMs;
    return AlertDialog(
      title: Text(context.tr("batch_scan_delay")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ChangeBatchScanDelayDialogWidget.format(context, _delayMs),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Slider(
            value: _delayMs.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: (max - min) ~/ step,
            onChanged: (value) => setState(() => _delayMs = value.round()),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(context.tr("ok")),
          onPressed: () => Navigator.of(context).pop(_delayMs),
        ),
      ],
    );
  }
}
