
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:good_manager/main.dart';
import 'package:vibration/vibration.dart';


class Utils{
  static void handleABarcodeFound() async{
    var enableSound = storage.getBarcodeScannerEnableBeep();
    var enableVibrate = storage.getBarcodeScannerEnableVibrate();
    if (enableSound){
      FlutterBeep.beep();
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