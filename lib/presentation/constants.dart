import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AppColors{
  static Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.black54;
  static Color greyColor = Color(0xFFF3F3F3);
}

class Config {
  static String supportEmail = "nhhoang1811vn@gmail.com";
  //static String dateTimeFormat = "yyyy-MM-dd";
  //static String displayDateTimeFormat = "dd/MM/yyyy";
  static DateTime minTime = DateTime(1900, 1, 1);
  static DateTime maxTime = DateTime(2101, 1, 1);

  static DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  static NumberFormat expenseAmountFormat = NumberFormat("0.##");
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
  static IconData barcodeIconData =  FontAwesomeIcons.barcode;

  static IconData homeIconData =  FontAwesomeIcons.house;
  static IconData goodIconData =  FontAwesomeIcons.boxOpen;

  static IconData groupIconData =  FontAwesomeIcons.solidFolder;//Icons.folder;//FontAwesomeIcons.folder;
  static IconData documentIconData = FontAwesomeIcons.book;
  static IconData supplierIconData = FontAwesomeIcons.userGroup;
  static IconData customerIconData = FontAwesomeIcons.userGroup;
  static IconData expenseIconData = FontAwesomeIcons.handHoldingDollar;
  static IconData reportIconData = FontAwesomeIcons.chartSimple;
  static IconData storeIconData = FontAwesomeIcons.shop;
  static IconData settingIconData = FontAwesomeIcons.gear;

  static const double screenSpace = 16.0;

  //static String appIconPath = "images/good.png";
  static String searchBarcodeIconPath = "images/search_barcode.png";
  //dimension
  static const double drawerMenuSize = 20.0;

  static const TextStyle fieldHintStyle =
      TextStyle(fontWeight: FontWeight.w300, color: Colors.black);
  static const String appName = "AppViet Quản Lý Kho";
  static const String appVersion = "1.0.0";
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