import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/home/home_skeleton.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _host(
  Widget child, {
  Brightness brightness = Brightness.light,
  double width = 400,
  double textScale = 1.0,
  bool disableAnimations = false,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: MediaQuery(
      data: MediaQueryData(
        size: Size(width, 800),
        textScaler: TextScaler.linear(textScale),
        disableAnimations: disableAnimations,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SizedBox(width: width - 32, child: child),
        ),
      ),
    ),
  );
}

Color _boneColor(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(HomeSkeletonBone),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  return (box.decoration as BoxDecoration).color!;
}

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('home_skeleton').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
  });

  testWidgets('bone pulses', (tester) async {
    await tester.pumpWidget(_host(const HomeSkeleton(
      child: HomeSkeletonBone(width: 40, height: 10),
    )));
    final before = _boneColor(tester);
    await tester.pump(const Duration(milliseconds: 550));
    expect(_boneColor(tester), isNot(before));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('bone with textStyle is as tall as that text', (tester) async {
    const style = TextStyle(fontSize: 18);
    await tester.pumpWidget(_host(const Column(children: [
      HomeSkeleton(child: HomeSkeletonBone(width: 40, textStyle: style)),
      Text('0', style: style),
    ])));
    final bone = tester.getSize(find.byType(HomeSkeletonBone));
    final text = tester.getSize(find.text('0').last);
    expect(bone.height, text.height);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('no animation when reduce motion is on', (tester) async {
    await tester.pumpWidget(_host(
      const HomeSkeleton(child: HomeSkeletonBone(width: 40, height: 10)),
      disableAnimations: true,
    ));
    final before = _boneColor(tester);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 550));
    expect(_boneColor(tester), before);
  });

  testWidgets('skeleton is hidden from semantics', (tester) async {
    await tester.pumpWidget(_host(const HomeSkeleton(
      child: HomeSkeletonBone(width: 40, height: 10),
    )));
    expect(
      find.ancestor(
        of: find.byType(HomeSkeletonBone),
        matching: find.byType(ExcludeSemantics),
      ),
      findsWidgets,
    );
    await tester.pumpWidget(const SizedBox());
  });

  final blocks = <String, Widget Function()>{
    // The single card has no pulse owner of its own; the row provides it.
    'stat card': () => const HomeSkeleton(child: HomeStatCardSkeleton()),
    'stats row': () => const HomeStatsRowSkeleton(),
    'documents card': () => const HomeDocumentsCardSkeleton(),
    'partners cards': () => const HomePartnersCardsSkeleton(),
    'row cards': () => const HomeRowCardsSkeleton(),
    'wallets': () => const HomeWalletsSkeleton(),
  };

  for (final brightness in Brightness.values) {
    for (final entry in blocks.entries) {
      testWidgets(
          '${entry.key} builds in ${brightness.name} at width 320 and text '
          'scale 2.0 without overflow', (tester) async {
        await tester.pumpWidget(_host(
          entry.value(),
          brightness: brightness,
          width: 320,
          textScale: 2.0,
        ));
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });
    }
  }

  testWidgets('stats row shows 2 cards when min quantity is off, 3 when on',
      (tester) async {
    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(showMinQuantity: false),
    );
    await tester.pumpWidget(_host(const HomeStatsRowSkeleton()));
    expect(find.byType(HomeStatCardSkeleton), findsNWidgets(2));

    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(showMinQuantity: true),
    );
    await tester.pumpWidget(_host(const HomeStatsRowSkeleton()));
    expect(find.byType(HomeStatCardSkeleton), findsNWidgets(3));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('documents card has an amount bone only when price is shown',
      (tester) async {
    AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(showPurchasePrice: false, showSalePrice: false),
    );
    await tester.pumpWidget(_host(const HomeDocumentsCardSkeleton()));
    final withoutAmount = find.byType(HomeSkeletonBone).evaluate().length;

    AppSettings.setGoodPropertiesSettings(GoodPropertiesSettings());
    await tester.pumpWidget(_host(const HomeDocumentsCardSkeleton()));
    final withAmount = find.byType(HomeSkeletonBone).evaluate().length;

    expect(
      AppSettings.getGoodPropertiesSettings()
          .showPriceFor(DocumentType.incoming),
      isTrue,
    );
    expect(withAmount, greaterThan(withoutAmount));
    await tester.pumpWidget(const SizedBox());
  });
}
