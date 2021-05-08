import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:good_manager/app/pages/home_page.dart';
import 'package:good_manager/app/utils/router.dart';

import 'pages/onboarding/on_boarding_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _router;

  MyApp() : _router = AppRouter() {
    //initLogger();
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
      home: HomePage(),
      onGenerateRoute: _router.getRoute,
      navigatorObservers: [_router.routeObserver],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: AppLocalizations.supportedLocales
,
      // ...,
    );
  }
}