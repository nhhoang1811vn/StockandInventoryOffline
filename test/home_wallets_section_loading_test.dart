import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/presentation/pages/home/home_skeleton.dart';
import 'package:good_manager/presentation/pages/home/home_wallets_section.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Empty translations: every title renders as its own key.
class _KeyLoader extends AssetLoader {
  const _KeyLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async => {};
}

Widget _host({required bool isLoading}) {
  return EasyLocalization(
    supportedLocales: const [Locale('en', 'US')],
    path: 'unused',
    assetLoader: const _KeyLoader(),
    child: Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: Scaffold(
          body: SingleChildScrollView(
            child: HomeWalletsSection(
              wallets: const [],
              selectedWalletId: null,
              totalBalance: 0,
              payments: const [],
              isLoading: isLoading,
              onWalletSelected: (_) {},
              onAddWallet: () {},
              onOpenWalletsPage: () {},
              onOpenPaymentsPage: () {},
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    Hive.init(Directory.systemTemp.createTempSync('wallets_loading').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
  });

  testWidgets('loading shows the wallets skeleton and no spinner or balance',
      (tester) async {
    await tester.pumpWidget(_host(isLoading: true));
    await tester.pump();

    expect(find.byType(HomeWalletsSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('total_balance'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('loaded shows no skeleton', (tester) async {
    await tester.pumpWidget(_host(isLoading: false));
    await tester.pump();

    expect(find.byType(HomeWalletsSkeleton), findsNothing);
    expect(find.byType(HomeSkeleton), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('total_balance'), findsOneWidget);
  });
}
