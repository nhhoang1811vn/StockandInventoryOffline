import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:good_manager/common/platform_support.dart';
import 'package:good_manager/constant/app_tokens.dart';
import 'package:good_manager/models/app_theme.dart';
import 'package:good_manager/presentation/app_theme_builder.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/router.dart';

import 'app_cubit.dart';
import 'core/services/app_lock_service.dart';
import 'core/services/notification_service.dart';
import 'di/di.dart';
import 'util/toast_utils.dart';

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

/// Phone-first UI: on wide screens (tablets, desktop windows, landscape)
/// content is centered and capped to [AppBreakpoints.contentMaxWidth].
Widget _capContentWidth(BuildContext context, Widget body) {
  final media = MediaQuery.of(context);
  if (media.size.width <= AppBreakpoints.contentMaxWidth) return body;
  return ColoredBox(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: AppBreakpoints.contentMaxWidth),
        child: MediaQuery(
          data: media.copyWith(
            size: Size(AppBreakpoints.contentMaxWidth, media.size.height),
          ),
          child: body,
        ),
      ),
    ),
  );
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AppRouter _router;
  MyAppState() : _router = AppRouter() {
  }

  @override
  void initState() {
    super.initState();
    NotificationService.init(navigatorKey: _router.navigatorKey);
    ToastUtils.init(_router.navigatorKey);
    getIt<AppLockService>().attach(_router.navigatorKey);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getIt<AppLockService>().onLifecycleChanged(state);
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorObserver? analyticsObserver = isMobilePlatform
        ? FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
        : null;

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
              // Only Android needs the reserved strip (transparent system
              // navigation bar). On iOS the per-screen SafeAreas already
              // handle the home indicator; reserving it here as well left a
              // large blank gap under the bottom bar.
              final reserveBottom =
                  defaultTargetPlatform == TargetPlatform.android;
              final bottomInset = !reserveBottom ||
                      mediaQuery.viewInsets.bottom > 0
                  ? 0.0
                  : (padding.bottom > 0 ? padding.bottom : viewPadding.bottom);
              final isDark = Theme
                  .of(context)
                  .brightness == Brightness.dark;
              final content = AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
                  statusBarBrightness:
                  isDark ? Brightness.dark : Brightness.light,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarIconBrightness:
                  isDark ? Brightness.light : Brightness.dark,
                  systemNavigationBarContrastEnforced: false,
                ),
                // Root safe area: the system navigation bar is transparent
                // (edge-to-edge), so reserve its height once here for every
                // route, dialog and bottom sheet. The reserved inset is then
                // removed from the MediaQuery padding so nested SafeAreas do
                // not add it twice. While the keyboard is open the Scaffold
                // already resizes for it, so no extra inset is reserved.
                child: ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: MediaQuery(
                      data: mediaQuery.copyWith(
                        padding: padding.copyWith(
                          top: padding.top > 0 ? padding.top : viewPadding.top,
                          bottom: reserveBottom ? 0 : padding.bottom,
                        ),
                        viewPadding: viewPadding.copyWith(
                            bottom: reserveBottom ? 0 : viewPadding.bottom),
                      ),
                      child: _capContentWidth(
                        context,
                        child ?? const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              );
              // Any touch anywhere (pushed routes and dialogs included) counts
              // as activity for the auto-lock idle clock.
              return Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (_) => getIt<AppLockService>().markActivity(),
                onPointerMove: (_) => getIt<AppLockService>().markActivity(),
                onPointerUp: (_) => getIt<AppLockService>().markActivity(),
                child: content,
              );
            },
            theme: buildAppTheme(state.theme.color, Brightness.light),
            darkTheme: buildAppTheme(state.theme.color, Brightness.dark),
            themeMode: state.theme.mode,
              onGenerateRoute: _router.getRoute,
              navigatorKey: _router.navigatorKey,
            navigatorObservers: [
              _router.routeObserver,
              if (analyticsObserver != null) analyticsObserver,
            ],
            localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              initialRoute: Pages.loading_data,
            );
          })
    );
  }
}
