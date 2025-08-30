import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/util/revenuecat_purchase_manager.dart';

import 'app.dart';
import 'common/storage/pref_storage.dart';
import 'data/app_settings.dart';
import 'di/di.dart';
import 'firebase_options.dart';

late List<CameraDescription> cameras;
//on the way remove this reference

bool justLogin = false;
//String initialRoute = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await NotificationService.init();
  await configureDependencies();
  var storage = await PrefStorage.init();
  await AppSettings.init(storage);
  await RevenueCatService.init();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(MyApp());
}
