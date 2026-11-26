import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/pages/home/home_online_app_promo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('popup flags', () {
    test('shows up to 3 times, then stops', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final results = <bool>[];
      for (var i = 0; i < 4; i++) {
        results.add(await OnlineAppPromo.shouldShowPopup(prefs));
      }
      expect(results, [true, true, true, false]);
    });

    test('skip stops it for good', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      expect(await OnlineAppPromo.shouldShowPopup(prefs), isTrue);
      await OnlineAppPromo.skipPopup(prefs);
      expect(await OnlineAppPromo.shouldShowPopup(prefs), isFalse);
    });

    test('flags from the old v2.0.0 popup do not hide the new one', () async {
      SharedPreferences.setMockInitialValues({
        'version_2_0_0_skipped': true,
        'version_2_0_0_show_count': 3,
      });
      final prefs = await SharedPreferences.getInstance();

      expect(await OnlineAppPromo.shouldShowPopup(prefs), isTrue);
    });
  });

  group('card', () {
    Widget host({VoidCallback? onTap, VoidCallback? onDownload}) => MaterialApp(
          home: Scaffold(
            body: HomeOnlineAppCard(
              title: 'Online app',
              subtitle: 'Work together',
              downloadLabel: 'Download now',
              hint: 'Tap to learn more',
              onTap: onTap ?? () {},
              onDownload: onDownload ?? () {},
            ),
          ),
        );

    testWidgets('has a single download action and no sync action',
        (tester) async {
      await tester.pumpWidget(host());

      expect(find.text('Online app'), findsOneWidget);
      expect(find.text('Work together'), findsOneWidget);
      expect(find.byKey(const Key('online_app_download')), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.textContaining('ync'), findsNothing);
    });

    testWidgets('download and card taps are separate', (tester) async {
      var cardTaps = 0, downloads = 0;
      await tester.pumpWidget(
          host(onTap: () => cardTaps++, onDownload: () => downloads++));

      await tester.tap(find.byKey(const Key('online_app_download')));
      expect([cardTaps, downloads], [0, 1]);

      await tester.tap(find.text('Work together'));
      expect([cardTaps, downloads], [1, 1]);
    });
  });
}
