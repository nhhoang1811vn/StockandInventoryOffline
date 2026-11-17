import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/data/app_settings.dart';

void main() {
  group('clampImageSize', () {
    test('raises values below the minimum to 256', () {
      expect(AppSettings.clampImageSize(0), 256);
    });
    test('lowers values above the maximum to 2048', () {
      expect(AppSettings.clampImageSize(99999), 2048);
    });
    test('keeps a value inside the range', () {
      expect(AppSettings.clampImageSize(512), 512);
    });
  });

  group('parseImageSize', () {
    test('accepts the boundaries', () {
      expect(AppSettings.parseImageSize('256'), 256);
      expect(AppSettings.parseImageSize(' 2048 '), 2048);
    });
    test('rejects out-of-range, empty, null and non-integer input', () {
      for (final input in ['255', '2049', '', null, 'abc', '512.5', '-300']) {
        expect(AppSettings.parseImageSize(input), isNull, reason: '$input');
      }
    });
  });
}
