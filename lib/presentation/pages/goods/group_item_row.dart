import 'package:good_manager/util/dimen.dart';
import 'package:flutter/material.dart';

import '../../../constant/constant.dart';
import '../../../domain/entity/entity.dart';
import '../../../util/base64_utils.dart';

class GroupItemRow extends StatelessWidget {
  final Group item;
  final Function(Group) onGroupTapped;
  final Function(Group) onGroupLongPressed;
  final bool isListTile;

  GroupItemRow(
    this.item,
    this.onGroupTapped,
    this.onGroupLongPressed, {
    this.isListTile = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isListTile) {
      return _buildListTile(context);
    }
    return _buildGridTile(context);
  }

  Widget _buildCardWrapper(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(Dimens.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onGroupTapped(item),
          onLongPress: () => onGroupLongPressed(item),
          borderRadius: BorderRadius.circular(Dimens.cardRadius),
          child: child,
        ),
      ),
    );
  }

  Widget _buildFolderIcon(BuildContext context,
      {double size = 54, double iconSize = 24}) {
    final theme = Theme.of(context);
    final bytes = tryDecodeBase64(item.file);

    if (bytes != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.tileRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.tileRadius),
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimens.tileRadius),
      ),
      child: Icon(
        UIConstants.groupIconData,
        color: theme.colorScheme.primary,
        size: iconSize,
      ),
    );
  }

  Widget _buildListTile(BuildContext context) {
    final theme = Theme.of(context);

    return _buildCardWrapper(
      context,
      Padding(
        padding: const EdgeInsets.all(Dimens.cardPadding),
        child: Row(
          children: [
            _buildFolderIcon(context, size: 64, iconSize: 28),
            const SizedBox(width: Dimens.tileGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context) {
    final theme = Theme.of(context);

    return _buildCardWrapper(
      context,
      Padding(
        padding: const EdgeInsets.all(Dimens.cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFolderIcon(context),
            const SizedBox(height: 10),
            Text(
              item.name,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                item.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
