import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../util/dimen.dart';
import 'base_dialog.dart';

class SelectOptionDialog extends BaseDialog {
  final String? title;
  final List<String> items;
  final Function(int)? onItemSelected;

  const SelectOptionDialog({
    super.key,
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
    final theme = Theme.of(context);
    final title = widget.title;
    final hasTitle = title != null && title.isNotEmpty;

    return Dialog(
      insetPadding: defaultInsetPadding,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 240, maxWidth: 320),
        child: IntrinsicWidth(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.spacingSmall),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hasTitle)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      Dimens.spacingMedium,
                      Dimens.spacingSmall,
                      Dimens.spacingMedium,
                      Dimens.spacingMini,
                    ),
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ...widget.items.mapIndexed(
                  (index, item) => InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onItemSelected?.call(index);
                    },
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.spacingMedium,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            item,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
