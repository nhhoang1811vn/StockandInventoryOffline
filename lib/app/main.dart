import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/app/pages/home/home_view.dart';
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
  static void setLocale(BuildContext context, String code) {
    MyAppState state = context.findAncestorStateOfType<MyAppState>();
    state.setLanguageCode(code);
  }

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  String _languageCode;
  final AppRouter _router;
  bool firstTime = false;

  MyAppState() : _router = AppRouter() {
    appDataManager.sharedPrefsHelper
        .getFirstTime()
        .then((value) => setState(() {
              firstTime = value;
            }));
  }

  void setLanguageCode(String code) {
    setState(() {
      _languageCode = code;
    });
  }

  @override
  void didChangeDependencies() {
    appDataManager.sharedPrefsHelper.getLanguageCode().then((code) {
      setState(() {
        _languageCode = code;
      });
    });
    super.didChangeDependencies();
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
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            //contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          )
        ),
        home: firstTime ? OnBoardingPage() : HomePage(),
        onGenerateRoute: _router.getRoute,
        navigatorObservers: [_router.routeObserver],
        locale: locale(_languageCode),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }
  }
}
