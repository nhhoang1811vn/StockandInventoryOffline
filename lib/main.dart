import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/auth_gate.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/pages/home/home_page.dart';
import 'package:good_manager/presentation/pages/onboarding/on_boarding_page.dart';
import 'package:good_manager/presentation/router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/helpers/injection.container.dart';
import 'firebase_options.dart';

late List<CameraDescription> cameras;

Storage storage = getIt<Storage>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await storage.init();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
  String? _languageCode;
  final AppRouter _router;
  bool? firstTime;

  MyAppState() : _router = AppRouter() {
    firstTime = storage.getFirstTime();
    _languageCode = "vi";
    //_languageCode = storage.getLanguageCode();
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
    var baseTheme = ThemeData(brightness: brightness,
      textTheme: TextTheme(
          displayLarge: TextStyle(),
          titleLarge: TextStyle(),
          titleMedium: TextStyle(
              fontSize: 17.0
          ),
          bodyMedium: TextStyle(
              fontSize: 15.0
          ),
          bodySmall: TextStyle(),
          displaySmall: TextStyle(
              fontSize: 12.0
          )
      ),
        colorScheme: ColorScheme.fromSeed(
          onBackground: Colors.black,
          onPrimary: Colors.blue.shade700,
          seedColor: Colors.blue.shade700,
          brightness: Brightness.light
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          //titleTextStyle: TextStyle(fontSize: ),
          //backgroundColor: Colors.white,
            iconTheme: IconThemeData(
                color: Colors.black
            )
        ),
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
    if (_languageCode == null || firstTime == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(Brightness.light),

        //theme: ThemeData(),
        home: AuthGate(),
        //home: firstTime! ? OnBoardingPage() : _homePage(),
        onGenerateRoute: _router.getRoute,
        navigatorObservers: [_router.routeObserver],
        //locale: locale(_languageCode!),
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }
  }
}
