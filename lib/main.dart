import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/util/revenuecat_purchase_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'common/storage/pref_storage.dart';
import 'data/app_settings.dart';
import 'di/di.dart';
import 'firebase_options.dart';

late List<CameraDescription> cameras;
bool justLogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //await NotificationService.init();
  await configureDependencies();
  await Hive.initFlutter();
  var storage = await PrefStorage.init();
  await AppSettings.initialize(storage);
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
  final auth = FirebaseAuth.instance;
  auth.authStateChanges().listen((user) async {
    if (user != null) {
      await RevenueCatService.updateUser(user.uid);
    }
  });
  if (auth.currentUser == null) {
    await auth.signInAnonymously();
  }else{
    //open app with valid user, sync the data
    //syncService.upload();
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
