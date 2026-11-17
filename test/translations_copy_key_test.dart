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
    test('$locale has action_copy', () {
      final file = File('assets/translations/$locale.json');
      final map = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      expect(map['action_copy'], isA<String>());
      expect((map['action_copy'] as String).trim(), isNotEmpty);
    });
  }
}
