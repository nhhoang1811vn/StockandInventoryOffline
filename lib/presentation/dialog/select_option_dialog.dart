import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../util/dimen.dart';
import 'base_dialog.dart';

class SelectOptionDialog extends BaseDialog {
  final String? title;
  final List<String> items;
  final Function(int)? onItemSelected;

  SelectOptionDialog({
    Key? key,
    required this.title,
    required this.items,
    required this.onItemSelected,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends BaseDialogState<SelectOptionDialog> {
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
            if ((widget.title ?? "").isNotEmpty) titleWidget(widget.title),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.items
                  .mapIndexed(
                    (index, item) => InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onItemSelected?.call(index);
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Text(item),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
