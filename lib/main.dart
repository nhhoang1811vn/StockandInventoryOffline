import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/data/storage.dart';
import 'package:good_manager/presentation/pages/login/auth_cubit.dart';
import 'package:good_manager/presentation/pages/login/loading_data.dart';
import 'package:good_manager/presentation/pages/login/login_page.dart';
import 'package:good_manager/presentation/router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/helpers/injection.container.dart';
import 'firebase_options.dart';
late List<CameraDescription> cameras;
Storage storage = getIt<Storage>();
bool justLogin = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await storage.init();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Enable Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  //runApp(MyApp());

  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
  });
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
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ),
        textTheme: TextTheme(
            displayLarge: TextStyle(),
            titleLarge: TextStyle(fontSize: 19.0),
            titleMedium: TextStyle(fontSize: 17.0),
            titleSmall: TextStyle(fontSize: 15.0),
            bodyMedium: TextStyle(fontSize: 15.0),
            bodySmall: TextStyle(),
            displaySmall: TextStyle(fontSize: 12.0)),
        colorScheme: ColorScheme.fromSeed(
            onSurface: Colors.black,
            onPrimary: Colors.blue.shade700,
            seedColor: Colors.blue.shade700,
            brightness: Brightness.light,
        ),
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.resolveWith<Color?>(
                (states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.blue.shade300;
              }
              return Colors.blue.withOpacity(0.5); // Inactive track color
            },
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
        ));

    return baseTheme.copyWith(
      //textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
      textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme)
    );
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(Brightness.light),
          onGenerateRoute: _router.getRoute,
          navigatorObservers: [_router.routeObserver],
          locale: locale(_languageCode),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
            if (snapshot.hasData){
              return BlocProvider(
                create: (context) => getIt<AuthCubit>(),
                child: LoadingData(),
              );
            }
            return BlocProvider(
              create: (context) => getIt<AuthCubit>(),
              child: LoginScreen(),
            ); //AuthGate();
          })
        );
    }
}
