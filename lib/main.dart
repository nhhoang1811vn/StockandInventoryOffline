import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/helpers/injection.container.dart';
import 'firebase_options.dart';

late List<CameraDescription> cameras;

Storage storage = getIt<Storage>();

late String initialRoute;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await storage.init();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen(
        (user) {
      if (user?.uid == null){// || !user.emailVerified) {
        initialRoute = Pages.signIn;
      } else {
        initialRoute = Pages.home;
      }
    },
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

  static void setLocale(BuildContext context, String code) async {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.changeLanguage(code);
  }
}

class MyAppState extends State<MyApp> {
  String _languageCode = "en";
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
        brightness: brightness,
        textTheme: TextTheme(
            displayLarge: TextStyle(),
            titleLarge: TextStyle(),
            titleMedium: TextStyle(fontSize: 17.0),
            bodyMedium: TextStyle(fontSize: 15.0),
            bodySmall: TextStyle(),
            displaySmall: TextStyle(fontSize: 12.0)),
        colorScheme: ColorScheme.fromSeed(
            onSurface: Colors.black,
            onPrimary: Colors.blue.shade700,
            seedColor: Colors.blue.shade700,
            brightness: Brightness.light),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
        //useMaterial3: false,
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
        ));

    return baseTheme.copyWith(
      textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(Brightness.light),
        initialRoute: initialRoute,
        onGenerateRoute: _router.getRoute,
        navigatorObservers: [_router.routeObserver],
        locale: locale(_languageCode),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }
}
