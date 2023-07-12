import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/home/home_view.dart';
import 'package:good_manager/presentation/pages/onboarding/on_boarding_page.dart';
import 'package:good_manager/presentation/router.dart';
import 'package:good_manager/data/storage.dart';

import '../common/helpers/injection.container.dart';

late List<CameraDescription> cameras;

Storage storage = getIt<Storage>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await storage.init();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  String? _languageCode;
  final AppRouter _router;
  bool? firstTime;
  //Storage storage = getIt<Storage>();

  MyAppState() : _router = AppRouter() {
    firstTime = storage.getFirstTime();
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
        home: firstTime! ? OnBoardingPage() : HomePage(),
        onGenerateRoute: _router.getRoute,
        navigatorObservers: [_router.routeObserver],
        locale: locale(_languageCode!),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }
  }
}
