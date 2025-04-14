import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/router.dart';

import '../common/helpers/injection.container.dart';
import 'firebase_options.dart';
late List<CameraDescription> cameras;
Storage storage = getIt<Storage>();
bool justLogin = false;
late String initialRoute;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
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
      if (user == null || !user.emailVerified) {
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
  State<StatefulWidget> createState() {
    return MyAppState();
  }

  static void setLocale(BuildContext context, String languageCode) async {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.changeLanguage(languageCode);
  }
  static LocaleType getDatePickerLocaleType(BuildContext context){
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    if (state?._languageCode == "vi")
      return LocaleType.vi;
    return LocaleType.en;
  }

}

class MyAppState extends State<MyApp> {

  String? _languageCode;
  final AppRouter _router;
  MyAppState() : _router = AppRouter() {
    _languageCode = storage.getLanguageCode();
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


  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(
        fontFamily: 'Roboto',
        brightness: brightness,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ),
        textTheme: TextTheme(
            titleSmall: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.blue.shade700; // Checked color
            }
            return Colors.white; // Unchecked color
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: Colors.grey.shade700), // Border when unchecked
        ),

        colorScheme: ColorScheme.fromSeed(
            onSurface: Colors.black,
            surface: Colors.white,
            onPrimary: Colors.blue.shade700,
            seedColor: Colors.blue.shade700,
            brightness: Brightness.light,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color?>(
              (states){
                if (states.contains(WidgetState.selected)){
                  return Colors.white;
                }
                return Colors.grey;
              }
          ),
          trackColor: WidgetStateProperty.resolveWith<Color?>(
                  (states){
                if (states.contains(WidgetState.selected)){
                  return Colors.blue.shade700;
                }
                return Colors.grey.shade100;
              }
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
        ));

    return baseTheme.copyWith(
      //textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
      //textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme)
      //  textTheme: GoogleFonts.gamjaFlowerTextTheme(baseTheme.textTheme),

    );
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          debugShowCheckedModeBanner: true,
          theme: _buildTheme(Brightness.light),
          onGenerateRoute: _router.getRoute,
          navigatorObservers: [_router.routeObserver],
          locale: locale(_languageCode!),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: initialRoute,
        );
    }
}
