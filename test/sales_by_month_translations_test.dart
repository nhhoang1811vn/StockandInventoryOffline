import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const locales = [
    'ar-SA',
    'de-DE',
    'en-US',
    'es-ES',
    'fr-FR',
    'hi-IN',
    'ja-JP',
    'pt-BR',
    'ru-RU',
    'vi-VN',
    'zh-CN',
  ];
  const keys = [
    'report_type_sales_by_month',
    'select_year',
    'month',
  ];

  for (final locale in locales) {
    for (final key in keys) {
      test('$locale has $key', () {
        final file = File('assets/translations/$locale.json');
        final map =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        expect(map[key], isA<String>());
        expect((map[key] as String).trim(), isNotEmpty);
      });
    }
  }
}
