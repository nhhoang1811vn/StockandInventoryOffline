import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:good_manager/main.dart';
import 'package:intl/intl.dart';

class Palette {
  static const Color green = Color(0xFF54b849);
  static const Color blue = Color(0xFF27397b);
  static const Color blue1 = Color(0xECF0F6FF);
  static const Color lightGray = Color(0xFFecf0f6);
  static const Color white = Color(0xFFf9f9f9);
  static const Color red = Color(0xFFdc0d2f);
  static const Color black = Color(0xFF2f3134);
  static const Color black1 = Color(0x171A1FFF);
  static const Color darkGrey = Color(0xFF585a5e);
  static const Color grey = Color(0xFF898a8b);
  static const Color dangerRed = Color(0xFFD20C13);
  static const Color neutralColor = Color(0xFF9095A0);
  static const Color neutral150 = Color(0xFFF8F9FA);
  static const Color neutral300 = Color(0xFFDEE1E6);
  static const Color neutral400 = Color(0xFFBCC1CA);
  static const Color neutral900 = Color(0xFF171A1F);
  static const Color yellow = Color(0xFFD1D100);
}
class AppColors{
  static Color primaryColor = Colors.blue;
  //static const Color secondaryColor = Colors.black;
  static const Color secondaryColor = Color(0xFF292929);
  //static Color greyColor = Color(0xFFF3F3F3);

  static Color greyColor = Color(0xFFB7B7B7);
}

class Config {
  static String supportEmail = "nhhoang1811vn@gmail.com";
  static DateTime minTime = DateTime(1900, 1, 1);
  static DateTime maxTime = DateTime(2101, 1, 1);

  //static DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  //static DateFormat dateFormat = DateFormat('MMMM d, yyyy');
  //static DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  //static NumberFormat doubleFormat =  NumberFormat("0.##");

  static NumberFormat currencyFormat = NumberFormat.currency(locale: "en_US", symbol: "");
  static NumberFormat simpleCurrencyFormat = NumberFormat.decimalPattern("en_US");
}
class DateFormatFactory{
  static DateFormat dateFormatEnglish = DateFormat("yyyy/MM/dd");
  static DateFormat dateFormatVietNam = DateFormat("dd/MM/yyyy");
  static DateFormat getDateFormat(){
    String code = storage.getLanguageCode();
    if (code == "en"){
      return dateFormatEnglish;
    }else{
      return dateFormatVietNam;
    }
  }
  static DateFormat dateAndTimeFormatEnglish = DateFormat("yyyy/MM/dd HH:mm");
  static DateFormat dateAndTimeFormatVietNam = DateFormat("dd/MM/yyyy HH:mm");
  static DateFormat getDateAndTimeFormat(){
    String code = storage.getLanguageCode();
    if (code == "en"){
      return dateAndTimeFormatEnglish;
    }else{
      return dateAndTimeFormatVietNam;
    }
  }
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

  //static IconData homeIconData =  FontAwesomeIcons.home;
  //static IconData goodIconData =  FontAwesomeIcons.boxOpen;
  //static IconData groupIconData =  FontAwesomeIcons.solidFolder;//Icons.folder;//FontAwesomeIcons.folder;
  //static IconData documentIconData = FontAwesomeIcons.book;
  static IconData supplierIconData = FontAwesomeIcons.userGroup;
  static IconData customerIconData = FontAwesomeIcons.userGroup;
  static IconData expenseIconData = FontAwesomeIcons.handHoldingDollar;
  static IconData reportIconData = FontAwesomeIcons.chartSimple;
  static IconData storeIconData = FontAwesomeIcons.shop;
  static IconData settingIconData = FontAwesomeIcons.gear;
  static IconData paymentIconData = Icons.credit_card;

  static const double screenSpace = 16.0;

  //static String appIconPath = "images/good.png";
  static String searchBarcodeIconPath = "assets/images/search_barcode.png";
  //dimension
  static const double drawerMenuSize = 20.0;

  static const TextStyle fieldHintStyle =
      TextStyle(fontWeight: FontWeight.w300, color: Colors.black);
  static const double progressBarOpacity = 0.6;
  static const Color progressBarColor = Colors.black;
  static Color primaryColor = Colors.blue[600]!;
  static Color primaryDarkColor = Colors.blue[800]!;

  static Color normalMenuColor = Colors.black;
  static Color highlightMenuColor = Colors.blue[700]!;
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