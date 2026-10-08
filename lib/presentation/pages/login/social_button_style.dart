import 'package:flutter/material.dart';

ButtonStyle socialAuthButtonStyle(
  BuildContext context, {
  required Color backgroundColor,
}) {
  return OutlinedButton.styleFrom(
    backgroundColor: backgroundColor,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    minimumSize: const Size(64, 48),
    side: BorderSide(color: Theme.of(context).colorScheme.outline),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32),
    ),
  );
}
