import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AppColors{
  static Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.black54;
}
class IntAppColors{
  static const int secondaryColor = 0x8A000000;
  static const int whiteColor = 0xFFFFFFFF;
}
class Config {
  static String supportEmail = "nhhoang1811vn@gmail.com";
  static String dateTimeFormat = "yyyy-MM-dd";
  static String displayDateTimeFormat = "dd/MM/yyyy";

  static DateTime minTime = DateTime(1900, 1, 1);
  static DateTime maxTime = DateTime(2101, 1, 1);

  static DateFormat dateFormat = DateFormat('dd/MM/yyyy');
}

class UIConstants {
  //dimension
  static const double appBarHeight = 58.0;
  //icons
  static IconData moreIconData = Icons.more_horiz;
  static IconData searchMenuIconData = Icons.search;
  static IconData sortMenuIconData = Icons.sort_by_alpha;
  static IconData helpMenuIconData = Icons.help;
  static IconData barcodeScannerMenuIconData = Icons.barcode_reader;
  static IconData calculatorIconData = FontAwesomeIcons.calculator;

  static IconData cancelIconData = Icons.close;

  static const double screenSpace = 16.0;

  static String appIconPath = "images/good.png";

  static String homeIconPath = "images/home.png";
  static String goodIconPath = "images/good.png";
  static String folderIconPath = "images/folder.png";
  static String storeIconPath = "images/store.png";
  static String customerIconPath = "images/customer.png";
  static String supplierIconPath = "images/supplier.png";
  static String documentIconPath = "images/document.png";
  static String expenseIconPath = "images/expense.png";
  static String reportIconPath = "images/report.png";

  static String ratingIconPath = "images/rating.png";
  static String feedbackIconPath = "images/feedback.png";
  static String helpIconPath = "images/help.png";
  static String whatsnewIconPath = "images/new.png";
  static String communityIconPath = "images/community.png";

  static String invitationIconPath = "images/invitation.png";
  static String settingsIconPath = "images/settings.png";
  static String barcodeIconPath = "images/barcode.png";
  static String searchBarcodeIconPath = "images/search_barcode.png";

  //dimension
  static const double drawerMenuSize = 24.0;

  static const TextStyle fieldHintStyle =
      TextStyle(fontWeight: FontWeight.w300, color: Colors.black);
  static const String appName = "Hotter'n Hell";
  static const double progressBarOpacity = 0.6;
  static const Color progressBarColor = Colors.black;
  static Color primaryColor = Colors.blue[600]!;
  static Color primaryDarkColor = Colors.blue[800]!;

  static Color normalMenuColor = Colors.white;
  static Color highlightMenuColor = Colors.orange[600]!;
}

void showInfoToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: UIConstants.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}