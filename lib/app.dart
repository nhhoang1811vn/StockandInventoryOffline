import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/router.dart';
import 'package:good_manager/util/revenuecat_purchase_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/notification_service.dart';

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
  String? _languageCode;
  ThemeMode _themeMode = ThemeMode.system;

  static const String _themeKey = 'user_theme_mode';
  final AppRouter _router;

  MyAppState() : _router = AppRouter() {
    _languageCode = AppSettings.getLanguageCode();
  }

  @override
  void initState() {
    super.initState();
    NotificationService.init(navigatorKey: _router.navigatorKey);
    _loadTheme();

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      print("authStateChanges: ${user?.uid}");
      if (user == null) {
        try {
          await RevenueCatService.logoutUser();
        } catch (e) {}
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _router.navigatorKey.currentState?.pushReplacementNamed(Pages.signIn);
        });
      } else {
        await RevenueCatService.updateUser(user.uid);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _router.navigatorKey.currentState
              ?.pushReplacementNamed(Pages.loading_data);
        });
      }
    });
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
    // Locale _temp;
    // switch (languageCode) {
    //   case "vi":
    //     _temp = Locale("vi", "VN");
    //     break;
    //   default:
    //     _temp = Locale("en", "US");
    // }
    return Locale(languageCode);
    //return _temp;
  }

  void changeLanguage(String code) {
    setState(() {
      _languageCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseLight = ThemeData.light();
    final baseDark = ThemeData.dark();

    final boldTextTheme = baseLight.textTheme.copyWith(
      titleSmall:
          baseLight.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      titleMedium: baseLight.textTheme.titleMedium
          ?.copyWith(fontWeight: FontWeight.w600),
    );

    final boldDarkTextTheme = baseDark.textTheme.copyWith(
      titleSmall:
          baseDark.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      titleMedium:
          baseDark.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    FirebaseAnalyticsObserver analyticsObserver =
        FirebaseAnalyticsObserver(analytics: analytics);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 230, 230, 236),
        cardTheme: CardThemeData(
          color: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.blue,
        ),
        textTheme: boldTextTheme,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
        cardTheme: const CardThemeData(
          color: Colors.black, // Black cards
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        textTheme: boldDarkTextTheme,
      ),
      themeMode: _themeMode,
      onGenerateRoute: _router.getRoute,
      navigatorKey: _router.navigatorKey,
      navigatorObservers: [_router.routeObserver, analyticsObserver],
      locale: locale(_languageCode!),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: Pages.splash,
    );
  }
}
