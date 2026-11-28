import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/pages/home/home_store_guide.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('shows when the flag is absent', () async {
    final prefs = await SharedPreferences.getInstance();
    expect(await HomeStoreGuide.shouldShow(prefs), isTrue);
  });

  test('reading does not mark it seen', () async {
    final prefs = await SharedPreferences.getInstance();
    expect(await HomeStoreGuide.shouldShow(prefs), isTrue);
    expect(await HomeStoreGuide.shouldShow(prefs), isTrue);
  });

  test('markSeen hides it for good', () async {
    final prefs = await SharedPreferences.getInstance();
    await HomeStoreGuide.markSeen(prefs);
    expect(await HomeStoreGuide.shouldShow(prefs), isFalse);
  });

  testWidgets('waitForRouteTransition completes after the push animation',
      (tester) async {
    final navKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navKey,
      home: const SizedBox(),
    ));
    final route = MaterialPageRoute<void>(builder: (_) => const SizedBox());
    navKey.currentState!.push(route);
    await tester.pump();

    var done = false;
    HomeStoreGuide.waitForRouteTransition(route).then((_) => done = true);
    await tester.pump(const Duration(milliseconds: 50));
    expect(done, isFalse);

    await tester.pumpAndSettle();
    expect(done, isTrue);
  });

  test('waitForRouteTransition returns at once without a route', () async {
    await HomeStoreGuide.waitForRouteTransition(null);
  });
}
