import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget{
  final IconData icon;
  final void Function() onPressed;

  CircleButton(this.icon, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 40,
      height: 40,
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
      child: Icon(
        icon,
        size: 24,
      ),
      shape: CircleBorder(),
    );
  }

}