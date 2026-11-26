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
    'restore_purchases',
    'restore_purchases_success',
    'restore_purchases_not_found',
    'restore_purchases_failed',
  ];

  for (final locale in locales) {
    test('$locale has the restore purchases strings', () {
      final file = File('assets/translations/$locale.json');
      final map = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      for (final key in keys) {
        expect(map[key], isA<String>(), reason: '$locale is missing $key');
        expect((map[key] as String).trim(), isNotEmpty);
      }
    });
  }
}
