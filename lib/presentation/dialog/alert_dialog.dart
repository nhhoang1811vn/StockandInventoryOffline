import 'package:flutter/material.dart';

import '../../util/dimen.dart';
import 'base_dialog.dart';

class CustomAlertDialog extends BaseDialog {
  final String title;
  final String message;
  final String positiveText;
  final String negativeText;
  final Function()? onNegativePressed;
  final Function()? onPositivePressed;
  final bool destructive;

  CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.positiveText,
    required this.negativeText,
    required this.onNegativePressed,
    required this.onPositivePressed,
    this.destructive = false,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends BaseDialogState<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: defaultInsetPadding,
      shape: shape,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.spacingLarge,
          horizontal: Dimens.spacingLarge,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: Dimens.textLarge),
            ),
            SizedBox(
              height: Dimens.spacingNormal,
            ),
            Text(widget.message),
            SizedBox(
              height: Dimens.spacingNormal,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(widget.negativeText),
                  onPressed: widget.onNegativePressed,
                ),
                TextButton(
                  style: widget.destructive
                      ? TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error)
                      : null,
                  child: Text(widget.positiveText),
                  onPressed: widget.onPositivePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
