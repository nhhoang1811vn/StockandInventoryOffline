import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/pages/contact_import/person_list_overflow_button.dart';

Widget host({
  bool showImport = true,
  VoidCallback? onImport,
  VoidCallback? onHelp,
}) =>
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(actions: [
          PersonListOverflowButton(
            importLabel: 'Import X',
            helpLabel: 'Help X',
            showImport: showImport,
            onImportFromContacts: onImport ?? () {},
            onHelp: onHelp ?? () {},
          ),
        ]),
      ),
    );

void main() {
  testWidgets('shows import then help', (tester) async {
    await tester.pumpWidget(host());
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    expect(find.text('Import X'), findsOneWidget);
    expect(find.text('Help X'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Import X')).dy,
        lessThan(tester.getTopLeft(find.text('Help X')).dy));
  });

  testWidgets('selecting import calls onImportFromContacts only',
      (tester) async {
    var imports = 0, helps = 0;
    await tester
        .pumpWidget(host(onImport: () => imports++, onHelp: () => helps++));
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Import X'));
    await tester.pumpAndSettle();
    expect([imports, helps], [1, 0]);
  });

  testWidgets('selecting help calls onHelp only', (tester) async {
    var imports = 0, helps = 0;
    await tester
        .pumpWidget(host(onImport: () => imports++, onHelp: () => helps++));
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Help X'));
    await tester.pumpAndSettle();
    expect([imports, helps], [0, 1]);
  });

  testWidgets('showImport false hides import', (tester) async {
    await tester.pumpWidget(host(showImport: false));
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    expect(find.text('Import X'), findsNothing);
    expect(find.text('Help X'), findsOneWidget);
  });
}
