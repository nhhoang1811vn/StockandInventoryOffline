import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/pages/home/home_store_header.dart';

Widget _host({required bool isPro, required VoidCallback onTap}) {
  return MaterialApp(
    home: Scaffold(
      body: HomeStoreHeader(
        storeName: 'My Shop',
        logoBytes: null,
        isPro: isPro,
        premiumLabel: 'PREMIUM',
        onTap: onTap,
      ),
    ),
  );
}

void main() {
  testWidgets('shows the store name with a switch icon and no account avatar',
      (tester) async {
    await tester.pumpWidget(_host(isPro: false, onTap: () {}));

    expect(find.text('My Shop'), findsOneWidget);
    expect(find.byKey(const Key('home_store_switch_icon')), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsNothing);
  });

  testWidgets('shows PREMIUM under the store name only for Pro',
      (tester) async {
    await tester.pumpWidget(_host(isPro: false, onTap: () {}));
    expect(find.text('PREMIUM'), findsNothing);

    await tester.pumpWidget(_host(isPro: true, onTap: () {}));
    expect(find.text('PREMIUM'), findsOneWidget);

    final nameBottom = tester.getBottomLeft(find.text('My Shop')).dy;
    final badgeTop = tester.getTopLeft(find.text('PREMIUM')).dy;
    expect(badgeTop, greaterThan(nameBottom));
  });

  testWidgets('tapping the logo, the name or the icon switches store',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(_host(isPro: true, onTap: () => taps++));

    await tester.tap(find.byIcon(Icons.store_rounded));
    await tester.tap(find.text('My Shop'));
    await tester.tap(find.byKey(const Key('home_store_switch_icon')));

    expect(taps, 3);
  });

  testWidgets('only the left part (logo, name, icon) is tappable',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(_host(isPro: true, onTap: () => taps++));

    final header = tester.getRect(find.byType(HomeStoreHeader));
    final tappable = tester.getRect(find.byType(GestureDetector).first);
    expect(tappable.width, lessThan(header.width / 2));

    // Empty space on the right of the row does nothing.
    await tester.tapAt(Offset(header.right - 8, header.center.dy));
    expect(taps, 0);

    await tester.tap(find.text('My Shop'));
    expect(taps, 1);
  });
}
