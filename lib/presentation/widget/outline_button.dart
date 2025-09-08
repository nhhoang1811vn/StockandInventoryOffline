import 'package:flutter/material.dart';

class MyOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const MyOutlineButton(this.text, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        text,
        style: TextStyle(
          //color: Colors.blue.shade700,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
