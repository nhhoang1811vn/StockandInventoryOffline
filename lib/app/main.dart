import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final AppRouter _router;
  bool firstTime = false;

  MyAppState() : _router = AppRouter() {
    appDataManager.sharedPrefsHelper
        .getFirstTime()
        .then((value) => setState(() {
              firstTime = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: firstTime ? OnBoardingPage() : MainPage(),
      onGenerateRoute: _router.getRoute,
      navigatorObservers: [_router.routeObserver],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // ...,
    );
  }
}