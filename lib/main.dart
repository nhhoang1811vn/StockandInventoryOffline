import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/util/revenuecat_purchase_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';
import 'common/platform_support.dart';
import 'common/storage/pref_storage.dart';
import 'data/app_settings.dart';
import 'di/di.dart';
import 'firebase_options.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    // sqflite has no desktop implementation: route it through FFI.
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  await EasyLocalization.ensureInitialized();
  //await NotificationService.init();
  await configureDependencies();
  await Hive.initFlutter();
  var storage = await PrefStorage.init();
  await AppSettings.initialize(storage);
  await RevenueCatService.init();
  if (isMobilePlatform) {
    cameras = await availableCameras();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // Crashlytics has no desktop implementation.
  if (isMobilePlatform) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
  }
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  if (isMobilePlatform) {
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'), // English
        Locale('es', 'ES'), // Spanish
        Locale('fr', 'FR'), // French
        Locale('de', 'DE'), // German
        Locale('zh', 'CN'), // Chinese (Simplified)
        Locale('ar', 'SA'), // Arabic
        Locale('hi', 'IN'), // Hindi
        Locale('pt', 'BR'), // Portuguese (Brazil)
        Locale('ru', 'RU'), // Russian
        Locale('ja', 'JP'), // Japanese
        Locale('vi', 'VN'), // Vietnamese
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      saveLocale: true,
      child: MyApp(),
    ),
  );
}
