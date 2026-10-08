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
    switch (context.locale.languageCode) {
      case 'vi':
        return LocaleType.vi;
      case 'zh':
        return LocaleType.zh;
      case 'ru':
        return LocaleType.ru;
      case 'fr':
        return LocaleType.fr;
      case 'es':
        return LocaleType.es;
      case 'de':
        return LocaleType.de;
      case 'ja':
        return LocaleType.jp;
      case 'pt':
        return LocaleType.pt;
      case 'ar':
        return LocaleType.ar;
      case 'hi':
        return LocaleType.hi;
      default:
        return LocaleType.en;
    }
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
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              final padding = mediaQuery.padding;
              final viewPadding = mediaQuery.viewPadding;
              return MediaQuery(
                data: mediaQuery.copyWith(
                  padding: padding.copyWith(
                    top: padding.top > 0 ? padding.top : viewPadding.top,
                    bottom: padding.bottom > 0
                        ? padding.bottom
                        : viewPadding.bottom,
                  ),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            theme: ThemeData.light().copyWith(
                appBarTheme: AppBarTheme(
                    titleTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                color: baseLight.colorScheme.onSurface,
              )),
              scaffoldBackgroundColor: Color.fromARGB(255, 241, 243, 244),
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
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: baseDark.colorScheme.onSurface,
                ),
              ),
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
