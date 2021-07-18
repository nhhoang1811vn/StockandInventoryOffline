import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UIConstants {
  static IconData moreIconData = Icons.more_horiz;
  static IconData searchMenuIconData = Icons.search;
  static IconData sortMenuIconData = Icons.sort_by_alpha;
  static IconData helpMenuIconData = Icons.help;

  static IconData cancelIconData = Icons.close;

  static const double screenSpace = 16.0;

  static String homeIconPath = "images/home.png";
  static String goodIconPath = "images/good.png";
  static String folderIconPath = "images/folder.png";
  static String storeIconPath = "images/store.png";
  static String customerIconPath = "images/customer.png";
  static String supplierIconPath = "images/supplier.png";
  static String documentIconPath = "images/document.png";
  static String expenseIconPath = "images/expense.png";
  static String reportIconPath = "images/report.png";
  static String calculatorIconPath = "images/calculator.png";

  static String ratingIconPath = "images/rating.png";
  static String feedbackIconPath = "images/feedback.png";
  static String communityIconPath = "images/community.png";

  static String invitationIconPath = "images/invitation.png";
  static String settingsIconPath = "images/settings.png";
  static String newIconPath = "images/new.png";
  static String barcodeIconPath = "images/barcode.png";

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
      toastLength: Toast.LENGTH_LONG,
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
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}