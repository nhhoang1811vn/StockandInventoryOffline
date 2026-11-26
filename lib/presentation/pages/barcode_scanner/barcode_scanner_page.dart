import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';

import '../../../data/app_settings.dart';

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
        title: Text(context.tr("scan_bar_code_title")),
        centerTitle: false,
        leading: IconButton(
          tooltip: context.tr('action_back'),
          icon: const Icon(Icons.arrow_back),
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
            if (rawValue != null) {
              handleABarcodeFound();
            }
            Navigator.pop(context, rawValue);
          }
        },
      ),
    );
  }

  void handleABarcodeFound() async {
    var enableSound = AppSettings.getBarcodeScannerEnableBeep();
    var enableVibrate = AppSettings.getBarcodeScannerEnableVibrate();
    if (enableSound) {
      //FlutterBeep.beep();
      await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
    }
    if (enableVibrate) {
      var vibrationCapabilities = await Vibration.hasVibrator();

      if (vibrationCapabilities == true) {
        Vibration.vibrate();
      }
    }
  }
}
