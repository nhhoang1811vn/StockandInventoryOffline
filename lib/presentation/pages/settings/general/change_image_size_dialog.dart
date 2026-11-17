import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/app_settings.dart';

class ChangeImageSizeDialogWidget extends StatefulWidget {
  final int size;

  const ChangeImageSizeDialogWidget(this.size, {Key? key}) : super(key: key);

  @override
  State createState() => _ChangeImageSizeDialogWidgetState();
}

class _ChangeImageSizeDialogWidgetState
    extends State<ChangeImageSizeDialogWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.size.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parsed = AppSettings.parseImageSize(_controller.text);
    return AlertDialog(
      title: Text(context.tr("image_size")),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 4,
        decoration: InputDecoration(
          suffixText: "px",
          errorText: parsed == null
              ? context.tr("image_size_error", args: [
                  AppSettings.minImageSize.toString(),
                  AppSettings.maxImageSize.toString(),
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
