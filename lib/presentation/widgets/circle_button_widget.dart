import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget{
  IconData icon;
  void Function() onPressed;

  CircleButton(this.icon, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 40,
      height: 40,
      onPressed: onPressed,
      color: Colors.blue,
      textColor: Colors.white,
      child: Icon(
        icon,
        size: 24,
      ),
      shape: CircleBorder(),
    );
  }

}