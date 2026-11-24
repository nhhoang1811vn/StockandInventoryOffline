import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/app_settings.dart';

/// Asks for the number of digits after the decimal point of quantities.
/// Pops the new value (0..6) or null when cancelled.
class ChangeQuantityDecimalsDialogWidget extends StatefulWidget {
  final int value;

  const ChangeQuantityDecimalsDialogWidget(this.value, {Key? key})
      : super(key: key);

  @override
  State createState() => _ChangeQuantityDecimalsDialogWidgetState();
}

class _ChangeQuantityDecimalsDialogWidgetState
    extends State<ChangeQuantityDecimalsDialogWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parsed = AppSettings.parseQuantityDecimals(_controller.text);
    return AlertDialog(
      title: Text(context.tr("decimal_digits")),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 1,
        decoration: InputDecoration(
          errorText: parsed == null ? context.tr("decimal_digits_error") : null,
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
