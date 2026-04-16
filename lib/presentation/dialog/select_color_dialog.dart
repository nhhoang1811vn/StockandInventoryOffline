import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../util/util.dart';
import 'base_dialog.dart';

class SelectColorDialog extends BaseDialog {
  final Color? color;
  final Function(Color)? onItemSelected;

  const SelectColorDialog({
    super.key,
    required this.color,
    this.onItemSelected,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends BaseDialogState<SelectColorDialog> {
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
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            titleWidget(context.tr("title_pick_color")),
            BlockPicker(
              pickerColor: widget.color,
              onColorChanged: (newColor) {
                widget.onItemSelected?.call(newColor);
              },
            ),
          ],
        ),
      ),
    );
  }
}
