import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/common/storage/pref_storage.dart';
import 'package:good_manager/data/app_settings.dart';
import 'package:good_manager/domain/entity/entity.dart';
import 'package:good_manager/util/quantity_input.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    Hive.init(Directory.systemTemp.createTempSync('qi_test').path);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings.initialize(PrefStorage(prefs: prefs));
    AppSettings.setSelectedStoreId(71);
  });

  void setDecimals(int n) => AppSettings.setGoodPropertiesSettings(
      GoodPropertiesSettings(quantityDecimals: n),
      storeId: 71);

  Future<TextEditingController> pump(WidgetTester tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TextField(
          controller: controller,
          keyboardType: quantityKeyboardType(),
          inputFormatters: quantityInputFormatters(),
        ),
      ),
    ));
    return controller;
  }

  testWidgets('with 2 digits a third decimal is ignored', (tester) async {
    setDecimals(2);
    final c = await pump(tester);
    await tester.enterText(find.byType(TextField), '1.25');
    expect(c.text, '1.25');
    await tester.enterText(find.byType(TextField), '1.256');
    expect(c.text, '1.25');
  });

  testWidgets('with 0 digits a dot is ignored', (tester) async {
    setDecimals(0);
    final c = await pump(tester);
    await tester.enterText(find.byType(TextField), '12');
    expect(c.text, '12');
    await tester.enterText(find.byType(TextField), '12.');
    expect(c.text, '12');
  });

  test('the keyboard offers a decimal point only when decimals are allowed',
      () {
    setDecimals(2);
    expect(quantityKeyboardType().decimal, isTrue);
    setDecimals(0);
    expect(quantityKeyboardType().decimal, isFalse);
  });

  test('explicit decimals override the Store setting', () {
    setDecimals(0);
    expect(quantityKeyboardType(3).decimal, isTrue);
  });
}
