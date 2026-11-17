import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/app_settings.dart';

class ChangeAutoLockDialogWidget extends StatefulWidget {
  final int minutes;

  const ChangeAutoLockDialogWidget(this.minutes, {Key? key}) : super(key: key);

  @override
  State createState() => _ChangeAutoLockDialogWidgetState();
}

class _ChangeAutoLockDialogWidgetState
    extends State<ChangeAutoLockDialogWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.minutes.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parsed = AppSettings.parseAutoLockMinutes(_controller.text);
    return AlertDialog(
      title: Text(context.tr("auto_lock_dialog_title")),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 4,
        decoration: InputDecoration(
          suffixText: context.tr("auto_lock_minutes_suffix"),
          errorText: parsed == null
              ? context.tr("auto_lock_minutes_error", args: [
                  AppSettings.minAutoLockMinutes.toString(),
                  AppSettings.maxAutoLockMinutes.toString(),
                ])
              : null,
        ),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) {
          if (parsed != null) Navigator.of(context).pop(parsed);
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text(context.tr("cancel")),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed:
              parsed == null ? null : () => Navigator.of(context).pop(parsed),
          child: Text(context.tr("ok")),
        ),
      ],
    );
  }
}
