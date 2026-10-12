import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UIConstants {
  //dimension
  static const double appBarHeight = 58.0;
  static const Color incomingDocumentColor = Colors.red;
  static const Color outgoingDocumentColor = Colors.green;

  //icons
  static IconData moreIconData = Icons.more_horiz;
  static IconData searchMenuIconData = Icons.search;
  static IconData sortMenuIconData = Icons.sort_by_alpha;
  static IconData helpMenuIconData = Icons.help;
  static IconData barcodeScannerMenuIconData = Icons.barcode_reader;
  static IconData calculatorIconData = FontAwesomeIcons.calculator.data;

  static IconData cancelIconData = Icons.close;
  static IconData barcodeIconData = FontAwesomeIcons.barcode.data;

  static IconData supplierIconData = Icons.local_shipping_rounded;
  static IconData customerIconData = FontAwesomeIcons.userGroup.data;
  static IconData expenseIconData = FontAwesomeIcons.handHoldingDollar.data;
  static IconData reportIconData = FontAwesomeIcons.chartSimple.data;
  static IconData storeIconData = Icons.store;
  static IconData settingIconData = Icons.settings;
  static IconData paymentIconData = FontAwesomeIcons.moneyBill.data;
  static IconData walletIconData = FontAwesomeIcons.wallet.data;

  static IconData goodIconData = FontAwesomeIcons.box.data;
  static IconData groupIconData = Icons.folder;

  static IconData documentIconData = FontAwesomeIcons.receipt.data;

  static const double screenSpace = 16.0;

  static String searchBarcodeIconPath = "assets/images/search_barcode.png";
}
