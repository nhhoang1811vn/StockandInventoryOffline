import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/localization/localization_constants.dart';
import 'package:good_manager/app/pages/main_page.dart';
import 'package:good_manager/app/pages/onboarding/on_boarding_view.dart';
import 'package:good_manager/app/utils/router.dart';
import 'package:good_manager/data/app_data_manager.dart';

List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    MyAppState state = context.findAncestorStateOfType<MyAppState>();
    state.setLocale(locale);
  }

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  final AppRouter _router;
  bool firstTime = false;

  MyAppState() : _router = AppRouter() {
    appDataManager.sharedPrefsHelper
        .getFirstTime()
        .then((value) => setState(() {
              firstTime = value;
            }));
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null || firstTime == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: firstTime ? OnBoardingPage() : MainPage(),
        onGenerateRoute: _router.getRoute,
        navigatorObservers: [_router.routeObserver],
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }
  }
}
