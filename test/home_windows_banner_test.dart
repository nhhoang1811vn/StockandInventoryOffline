import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/pages/home/home_windows_banner.dart';

void main() {
  testWidgets('banner shows texts, forwards taps and cannot be dismissed',
      (tester) async {
    var downloads = 0, guides = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: HomeWindowsBanner(
          title: 'Now on Windows',
          message: 'Download it',
          downloadLabel: 'Download',
          guideLabel: 'Guide',
          onDownload: () => downloads++,
          onGuide: () => guides++,
        ),
      ),
    ));

    expect(find.text('Now on Windows'), findsOneWidget);
    expect(find.text('Download it'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsNothing);

    await tester.tap(find.byKey(const Key('windows_banner_download')));
    await tester.tap(find.byKey(const Key('windows_banner_guide')));

    expect([downloads, guides], [1, 1]);
  });

  testWidgets('banner uses the same card surface as the other cards',
      (tester) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final theme = ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: brightness,
        cardTheme: CardThemeData(
          color: brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
        ),
      );
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
          body: HomeWindowsBanner(
            title: 'Now on Windows',
            message: 'Download it',
            downloadLabel: 'Download',
            guideLabel: 'Guide',
            onDownload: () {},
            onGuide: () {},
          ),
        ),
      ));
      await tester.pumpAndSettle(); // let the theme change finish animating

      final card =
          tester.widget<Material>(find.byKey(const Key('windows_banner_card')));
      expect(card.color, theme.cardTheme.color, reason: '$brightness');
      expect(card.borderRadius, BorderRadius.circular(22));
    }
  });
}
