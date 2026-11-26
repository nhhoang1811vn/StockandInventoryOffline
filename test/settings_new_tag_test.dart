import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/pages/menu/bloc/menu_cubit.dart';
import 'package:good_manager/presentation/pages/menu/menu_page.dart';
import 'package:good_manager/presentation/pages/settings/settings_page.dart';
import 'package:good_manager/presentation/widget/settings_ui.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serves translations from memory so the test does not touch the asset bundle.
class _TestLoader extends AssetLoader {
  const _TestLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async => {
        'tag_new': 'New',
        'good_properties': 'Good properties',
        'document_properties': 'Document properties',
      };
}

Future<void> _pump(WidgetTester tester, Widget page) async {
  tester.view.physicalSize = const Size(800, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(EasyLocalization(
    supportedLocales: const [Locale('en', 'US')],
    path: 'unused',
    assetLoader: const _TestLoader(),
    child: Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: page,
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

/// The "New" tag inside the row whose title is [title].
Finder _tagIn(String title) => find.descendant(
      of: find.ancestor(
        of: find.text(title),
        matching: find.byType(ListTile),
      ),
      matching: find.text('New'),
    );

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    Hive.init(Directory.systemTemp.createTempSync('new_tag_test').path);
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

  testWidgets('SettingsMenuItem shows its tag after the title only when given',
      (tester) async {
    await _pump(
      tester,
      const Scaffold(
        body: Column(children: [
          SettingsMenuItem(
            icon: Icons.star,
            title: 'With tag',
            tag: Text('New'),
          ),
          SettingsMenuItem(icon: Icons.star, title: 'Without tag'),
        ]),
      ),
    );

    expect(_tagIn('With tag'), findsOneWidget);
    expect(_tagIn('Without tag'), findsNothing);
    final titleRight = tester.getTopRight(find.text('With tag')).dx;
    expect(tester.getTopLeft(find.text('New')).dx, greaterThan(titleRight));
  });

  testWidgets('Settings page tags Good and Document properties as new',
      (tester) async {
    await _pump(tester, SettingsPage());

    expect(_tagIn('Good properties'), findsOneWidget);
    expect(_tagIn('Document properties'), findsOneWidget);
    expect(find.text('New'), findsNWidgets(2));
  });

  testWidgets('Menu tab tags Good and Document properties as new',
      (tester) async {
    await _pump(
      tester,
      BlocProvider(create: (_) => MenuCubit(), child: MenuPage()),
    );

    expect(_tagIn('Good properties'), findsOneWidget);
    expect(_tagIn('Document properties'), findsOneWidget);
    expect(find.text('New'), findsNWidgets(2));
  });
}
