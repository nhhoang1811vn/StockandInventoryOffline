import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/data/app_settings.dart';

// AppSettings is never initialised in this file (each test file runs in its own
// isolate), like the report row builder tests.
void main() {
  test('getQuantityDecimals falls back to 2 when storage is not initialised',
      () {
    expect(AppSettings.getQuantityDecimals(), 2);
  });
}
