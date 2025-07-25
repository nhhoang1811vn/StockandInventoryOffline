import 'dart:convert';
import 'dart:io';

void main() {
  final arbFile = File('lib/l10n/app_en.arb');
  final arbContent = json.decode(arbFile.readAsStringSync()) as Map<String, dynamic>;
  final keys = arbContent.keys.where((k) => !k.startsWith('@')).toList();

  final sourceFiles = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  for (final key in keys) {
    bool used = sourceFiles.any((file) {
      final content = file.readAsStringSync();
      return content.contains('"$key"') || content.contains("'$key'");
    });

    if (!used) {
      print('Unused key: $key');
    }
  }
}
