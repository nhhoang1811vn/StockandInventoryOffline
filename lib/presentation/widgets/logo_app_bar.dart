import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage('assets/images/app_icon.png'),
            width: 36,
          ),
          SizedBox(width: 8),
          Text(
            "Stock and Inventory",
            style: GoogleFonts.playfairDisplay(),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
