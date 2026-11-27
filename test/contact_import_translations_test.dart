import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('contact imports: every locale defines action_import_from_contacts', () {
    final files = Directory('assets/translations')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList();
    expect(files.length, 11);
    for (final f in files) {
      final map = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      final value = map['action_import_from_contacts'];
      expect(value, isA<String>(), reason: f.path);
      expect((value as String).trim(), isNotEmpty, reason: f.path);
    }
  });
}
