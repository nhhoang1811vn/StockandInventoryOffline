import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/pages/menu/bloc/menu_cubit.dart';
import 'package:good_manager/presentation/pages/menu/menu_page.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Empty translations: every title renders as its own key.
class _KeyLoader extends AssetLoader {
  const _KeyLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async => {};
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    Hive.init(Directory.systemTemp.createTempSync('menu_mgmt_test').path);
    PackageInfo.setMockInitialValues(
      appName: 'app',
      packageName: 'pkg',
      version: '1.0.97',
      buildNumber: '118',
      buildSignature: '',
    );
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
  });

  testWidgets(
      'Menu inventory card drops the entries Home already offers',
      (tester) async {
    tester.view.physicalSize = const Size(800, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(EasyLocalization(
      supportedLocales: const [Locale('en', 'US')],
      path: 'unused',
      assetLoader: const _KeyLoader(),
      child: Builder(
        builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: BlocProvider(create: (_) => MenuCubit(), child: MenuPage()),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    // Still in the Menu.
    expect(find.text('stores'), findsOneWidget);
    expect(find.text('payments_title'), findsOneWidget);
    expect(find.text('categories'), findsOneWidget);

    // Removed: Home has them.
    expect(find.text('documents'), findsNothing);
    expect(find.text('title_wallet'), findsNothing);
    expect(find.text('suppliers'), findsNothing);
    expect(find.text('customers'), findsNothing);
  });
}
