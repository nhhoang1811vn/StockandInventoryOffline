import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UIConstants {
  static IconData goodsIconData = FontAwesomeIcons.bookOpen;
  static IconData documentsIconData = FontAwesomeIcons.book;
  static IconData calculatorIconData = FontAwesomeIcons.calculator;

  static IconData searchMenuIconData = Icons.search;
  static IconData sortMenuIconData = Icons.sort_by_alpha;
  static IconData helpMenuIconData = Icons.help;

  static IconData cancelIconData = Icons.close;

  static const double screenSpace = 16.0;

  static const TextStyle fieldHintStyle =
      TextStyle(fontWeight: FontWeight.w300, color: Colors.black);
  static const String appName = "Hotter'n Hell";
  static const double progressBarOpacity = 0.6;
  static const Color progressBarColor = Colors.black;
  static Color primaryColor = Colors.blue[600];
  static Color primaryDarkColor = Colors.blue[800];

  static Color normalMenuColor = Colors.white;
  static Color highlightMenuColor = Colors.orange[600];
}
void showInfoToast(msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: UIConstants.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
void showErrorToast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}