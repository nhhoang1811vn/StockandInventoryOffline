import 'package:flutter/material.dart';

import '../../constant/ui_constants.dart';

class SaveObjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  const SaveObjectAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(UIConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actionsIconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actions: actions,
    );
  }
}
