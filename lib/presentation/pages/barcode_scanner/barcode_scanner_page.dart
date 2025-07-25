import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';

import '../../../main.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.scan_bar_code_title),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          facing: CameraFacing.back,
          detectionSpeed: DetectionSpeed.normal,
        ),
        //allowDuplicates: false,
        onDetect: (capture) {
          if (!isScanned) {
            final barcode = capture.barcodes.first;
            final String? rawValue = barcode.rawValue;
            setState(() => isScanned = true);
            if (rawValue != null){
              handleABarcodeFound();
            }
            Navigator.pop(context, rawValue);
          }
        },
      ),
    );
  }
  void handleABarcodeFound() async{
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
}
