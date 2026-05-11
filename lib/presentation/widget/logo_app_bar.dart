import 'package:flutter/material.dart';
import 'package:good_manager/constant/config.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage('assets/images/app_logo.png'),
            width: 36,
          ),
          SizedBox(width: 8),
          Text(
            Config.appName,
            style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}