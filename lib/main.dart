import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/router.dart';
import 'package:good_manager/purchase_manager.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../common/helpers/injection.container.dart';
import 'firebase_options.dart';

late List<CameraDescription> cameras;
//Storage storage = getIt<Storage>();
late Storage storage;
bool justLogin = false;
late String initialRoute;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  storage = getIt<Storage>();
  await storage.init();
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
  FirebaseAuth.instance.authStateChanges().listen(
    (user) {
      //if (user == null || !user.emailVerified) {
      if (user == null) {
        initialRoute = Pages.signIn;
      } else {
        initialRoute = Pages.loading_data;
      }
    },
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();

  static void setLocale(BuildContext context, String languageCode) async {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.changeLanguage(languageCode);
  }

  static LocaleType getDatePickerLocaleType(BuildContext context) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    if (state?._languageCode == "vi") return LocaleType.vi;
    return LocaleType.en;
  }
}
class MyAppState extends State<MyApp> {
  final purchaseManager = PurchaseManager();
  String? _languageCode;
  ThemeMode _themeMode = ThemeMode.system;

  static const String _themeKey = 'user_theme_mode';
  final AppRouter _router;
  MyAppState() : _router = AppRouter() {
    _languageCode = storage.getLanguageCode();
  }
  @override
  void initState() {
    super.initState();
    purchaseManager.init();
    _loadTheme();

  }
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    setState(() {
      switch (themeString) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode = ThemeMode.system;
      }
    });
  }
  Future<void> changeTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _themeMode = mode;
    });
    switch (mode) {
      case ThemeMode.light:
        await prefs.setString(_themeKey, 'light');
        break;
      case ThemeMode.dark:
        await prefs.setString(_themeKey, 'dark');
        break;
      case ThemeMode.system:
        await prefs.setString(_themeKey, 'system');
        break;
    }
  }


  Locale locale(String languageCode) {
    Locale _temp;
    switch (languageCode) {
      case "vi":
        _temp = Locale("vi", "VN");
        break;
      default:
        _temp = Locale("en", "US");
    }
    return _temp;
  }

  changeLanguage(String code) {
    setState(() {
      _languageCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade700,
          primary: Colors.blue.shade700,
          onPrimary: Colors.white,
            //brightness: Brightness.light
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade700,
            primary: Colors.blue.shade700,
            onPrimary: Colors.white,
            brightness: Brightness.dark),
      ),
      themeMode: _themeMode,
      onGenerateRoute: _router.getRoute,
      navigatorObservers: [_router.routeObserver],
      locale: locale(_languageCode!),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: initialRoute,
    );
  }
}
