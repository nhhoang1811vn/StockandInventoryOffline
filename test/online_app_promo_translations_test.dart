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

  for (final locale in locales) {
    test('$locale names the Online app instead of a version number', () {
      final file = File('assets/translations/$locale.json');
      final map = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      for (final key in ['v2_announcement_title', 'whats_new_v2_title']) {
        final value = map[key] as String;
        expect(value, contains('Stock & Inventory: Cloud Sync'), reason: '$locale $key');
        expect(value, isNot(contains('2.0.0')), reason: '$locale $key');
      }
    });
  }
}
