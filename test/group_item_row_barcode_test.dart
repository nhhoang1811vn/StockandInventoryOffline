import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/presentation/pages/goods/group_item_row.dart';

Group _group({String? barcode, String description = ''}) => Group()
  ..name = 'Drinks'
  ..description = description
  ..barCode = barcode
  ..storeId = 1;

Future<void> _pump(
  WidgetTester tester,
  Group group, {
  required bool showBarcode,
  required bool isListTile,
}) async {
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: GroupItemRow(
        group,
        (_) {},
        (_) {},
        isListTile: isListTile,
        showBarcode: showBarcode,
      ),
    ),
  ));
}

void main() {
  group('list layout (1 column)', () {
    testWidgets('shows the barcode and description', (tester) async {
      await _pump(tester, _group(barcode: 'BC-123', description: 'Cold'),
          showBarcode: true, isListTile: true);
      expect(find.text('BC-123'), findsOneWidget);
      expect(find.text('Cold'), findsOneWidget);
    });

    testWidgets('hides the barcode when the property is off', (tester) async {
      await _pump(tester, _group(barcode: 'BC-123'),
          showBarcode: false, isListTile: true);
      expect(find.text('BC-123'), findsNothing);
      expect(find.text('Drinks'), findsOneWidget);
    });

    testWidgets('shows nothing for a missing or empty barcode', (tester) async {
      await _pump(tester, _group(barcode: null),
          showBarcode: true, isListTile: true);
      expect(find.byIcon(Icons.qr_code), findsNothing);
      await _pump(tester, _group(barcode: ''),
          showBarcode: true, isListTile: true);
      expect(find.byIcon(Icons.qr_code), findsNothing);
    });
  });

  group('grid layout (2 and 3 columns), like a Good tile', () {
    testWidgets('shows only the name: no barcode, no description',
        (tester) async {
      await _pump(tester, _group(barcode: 'BC-123', description: 'Cold'),
          showBarcode: true, isListTile: false);
      expect(find.text('Drinks'), findsOneWidget);
      expect(find.text('BC-123'), findsNothing);
      expect(find.text('Cold'), findsNothing);
      expect(find.byIcon(Icons.qr_code), findsNothing);
    });
  });
}
