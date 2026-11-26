import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/pages/report/bloc/report_cubit.dart';
import 'package:good_manager/presentation/pages/report/report_page.dart';
import 'package:good_manager/presentation/widget/settings_ui.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serves translations from memory so the test does not touch the asset bundle.
class _TestLoader extends AssetLoader {
  const _TestLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async =>
      {'tag_new': 'New'};
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    Hive.init(Directory.systemTemp.createTempSync('report_layout_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
  });

  Future<void> pumpReport(WidgetTester tester) async {
    // Tall screen so the lazy ListView builds every group.
    tester.view.physicalSize = const Size(800, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(EasyLocalization(
      supportedLocales: const [Locale('en', 'US')],
      path: 'unused',
      assetLoader: const _TestLoader(),
      fallbackLocale: const Locale('en', 'US'),
      child: Builder(
        builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: BlocProvider(
            create: (_) => ReportCubit(),
            child: ReportPage(),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('report rows use the same tile metrics as the settings rows',
      (tester) async {
    await pumpReport(tester);

    final tiles = tester.widgetList<ListTile>(find.byType(ListTile)).toList();
    expect(tiles, isNotEmpty);
    for (final tile in tiles) {
      expect(tile.contentPadding,
          const EdgeInsets.symmetric(horizontal: 20, vertical: 4));
    }
    expect(find.byType(SettingsMenuItem), findsNWidgets(tiles.length));
  });

  testWidgets('report groups use the shared card and section header',
      (tester) async {
    await pumpReport(tester);

    expect(find.byType(SettingsMenuCard), findsNWidgets(5));
    expect(find.byType(SettingsSectionHeader), findsNWidgets(5));
  });

  testWidgets('Sales and Purchase headers keep their New tag', (tester) async {
    await pumpReport(tester);

    expect(find.text('New'), findsNWidgets(2));
  });
}
