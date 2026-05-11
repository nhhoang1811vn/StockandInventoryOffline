import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:good_manager/models/app_theme.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/router.dart';

import 'app_cubit.dart';
import 'core/services/notification_service.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();

  static LocaleType getDatePickerLocaleType(BuildContext context) {
    return LocaleType.en;
  }
}

class MyAppState extends State<MyApp> {
  final AppRouter _router;
  MyAppState() : _router = AppRouter() {
  }

  @override
  void initState() {
    super.initState();
    NotificationService.init(navigatorKey: _router.navigatorKey);
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

    return BlocProvider(
      create: (_) => AppCubit(),
      child:  BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light().copyWith(
                appBarTheme: AppBarTheme(
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    )),
                scaffoldBackgroundColor: Color.fromARGB(255, 230, 230, 236),
                  cardTheme: CardThemeData(
                    color: Colors.white,
                  ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: state.theme.color,
                  brightness: Brightness.light,
                ),
                textTheme: boldTextTheme,
              ),
              darkTheme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
                  cardTheme: const CardThemeData(
                    color: Colors.black, // Black cards
                  ),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: state.theme.color,
                  brightness: Brightness.dark,
                ),
                textTheme: boldDarkTextTheme,
              ),
              themeMode: state.theme.mode,
              onGenerateRoute: _router.getRoute,
              navigatorKey: _router.navigatorKey,
              navigatorObservers: [_router.routeObserver, analyticsObserver],
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              initialRoute: Pages.loading_data,
            );
          })
    );
  }
}
