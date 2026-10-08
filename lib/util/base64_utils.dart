import 'dart:convert';
import 'dart:typed_data';

Uint8List? tryDecodeBase64(String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    return base64Decode(value);
  } catch (_) {
    return null;
  }
}

List<Uint8List> tryDecodeBase64List(List<dynamic>? values) {
  if (values == null) return [];
  return values
      .map((value) => tryDecodeBase64(value as String?))
      .whereType<Uint8List>()
      .toList();
}
