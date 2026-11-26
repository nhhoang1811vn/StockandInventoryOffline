import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/widget/settings_ui.dart';

void main() {
  testWidgets('title uses the shared sheet style', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: SettingsBottomSheetTitle(title: 'Pick one')),
    ));

    final text = tester.widget<Text>(find.text('Pick one'));
    final base = Theme.of(tester.element(find.text('Pick one')))
        .textTheme
        .titleMedium!;
    expect(text.style?.fontSize, base.fontSize);
    expect(text.style?.fontWeight, FontWeight.w800);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('optional close button calls onClose', (tester) async {
    var closed = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SettingsBottomSheetTitle(
          title: 'Pick one',
          onClose: () => closed++,
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.close));
    expect(closed, 1);
  });

  test('sheet list tiles share one horizontal padding that matches the title',
      () {
    expect(kBottomSheetTilePadding,
        const EdgeInsets.symmetric(horizontal: 20));
  });
}
