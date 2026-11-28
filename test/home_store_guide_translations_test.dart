import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('home store guide: every locale defines the guide strings', () {
    const keys = ['home_store_guide_title', 'home_store_guide_body', 'got_it'];
    final files = Directory('assets/translations')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList();
    expect(files.length, 11);
    for (final f in files) {
      final map = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      for (final key in keys) {
        final value = map[key];
        expect(value, isA<String>(), reason: '${f.path} $key');
        expect((value as String).trim(), isNotEmpty, reason: '${f.path} $key');
      }
    }
  });
}
