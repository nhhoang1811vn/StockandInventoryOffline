
import 'package:audioplayers/audioplayers.dart';
//import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:good_manager/domain/entities/document.dart';
import 'package:good_manager/domain/entities/document_paid_status.dart';
import 'package:good_manager/main.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:vibration/vibration.dart';

class DateTimeUtils{
  static DateTime addMonths(DateTime currentDate, int monthsToAdd) {
    // Calculate the new month
    int newMonth = currentDate.month + monthsToAdd;
    int newYear = currentDate.year;

    // Adjust the year and month if the month exceeds 12 or is less than 1
    while (newMonth > 12) {
      newMonth -= 12;
      newYear += 1;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear -= 1;
    }

    // Create the new DateTime
    DateTime newDate = DateTime(newYear, newMonth, currentDate.day);

    // If the new month has fewer days than the original day, adjust the day
    if (newDate.month != newMonth) {
      newDate = DateTime(newYear, newMonth + 1, 0); // Last day of the new month
    }

    return newDate;
  }
}
class Utils{
  static DocumentPaidStatus getStatus(Document document){
    var amount = document.amount;
    var paid = document.paid;
    if (amount == 0.0 || paid >= amount) {
      return DocumentPaidStatus.paid;
    } else if (paid == 0.0) {
      return DocumentPaidStatus.unpaid;
    } else {
      return DocumentPaidStatus.partial;
    }
  }
  static String formatNumber(double value) {
    if (value >= 1e9) {
      // Billions (1e9 = 1,000,000,000)
      return '${(value / 1e9).toStringAsFixed(1)}B'; // 1 decimal place for billions
    } else if (value >= 1e6) {
      // Millions (1e6 = 1,000,000)
      return '${(value / 1e6).toStringAsFixed(1)}M'; // 1 decimal place for millions
    } else if (value >= 1e3) {
      // Thousands (1e3 = 1,000)
      return '${(value / 1e3).toStringAsFixed(0)}K'; // No decimals for thousands
    } else {
      return value.toStringAsFixed(0); // Show the value as it is for smaller numbers
    }
  }

  static String getQuantityText(double num){
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return num.toString().replaceAll(regex, '');
  }
  static AudioPlayer _audioPlayer = AudioPlayer();
  static Future<String?> scanBarcode(BuildContext context) async{
    String? result = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: 'Scan Bar code',
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: false,
      delayMillis: 2000,
      cameraFace: CameraFace.back,
    );
    if (result != null && result != "-1"){
      handleABarcodeFound();
    }
    if ("-1" == result){
      return null;
    }
    return result;
  }
  static void handleABarcodeFound() async{
    var enableSound = storage.getBarcodeScannerEnableBeep();
    var enableVibrate = storage.getBarcodeScannerEnableVibrate();
    if (enableSound){
      //FlutterBeep.beep();
      await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
    }
    if (enableVibrate){
      var vibrationCapabilities = await Vibration.hasVibrator();

      if (vibrationCapabilities == true) {
        Vibration.vibrate();
      }
    }
  }

  static bool sameFiles(List<String> files1, List<String> files2){
    if (files1.length != files2.length){
      return false;
    }
    for (var i = 0; i < files1.length ;i++){
      if (files1[i] != files2[i]){
        return false;
      }
    }
    return true;
  }
  static void showCalculatorPopup(BuildContext context,double? value, Function(double) callback) async {
    var calc = SimpleCalculator(
      value: value ?? 0,
      onChanged: (key, value, expression) {
        if (value != null){
          callback(value);
        }
      },
      theme: const CalculatorThemeData(
        displayColor: Colors.white,
        displayStyle: const TextStyle(fontSize: 20, color: Colors.blue),
      ),
    );
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(height: MediaQuery.of(context).size.height * 0.75, child: calc);
        });
  }
}
class ColorUtils{
  static Color getItemBgColor1(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade900
          : Colors.white;

  static Color getItemBgColor2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.blueGrey.shade800
          : Colors.blue.shade50;
  static Color getHeaderBgColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.blueGrey.shade900
          : Colors.blue.shade100;
}