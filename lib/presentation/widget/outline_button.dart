import 'package:flutter/material.dart';

/// Secondary action. Style comes from `outlinedButtonTheme`.
/// Pass [icon] for a leading icon; the label then shrinks to fit one line.
class MyOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const MyOutlineButton(this.text, this.onPressed, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return OutlinedButton(onPressed: onPressed, child: Text(text));
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text, maxLines: 1),
      ),
    );
  }
}
