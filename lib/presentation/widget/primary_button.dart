import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  PrimaryButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary

      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
