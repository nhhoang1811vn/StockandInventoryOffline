import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/pages/contact_import/contact_import_service.dart';

void main() {
  test('requests contacts permission on Android only', () {
    expect(ContactImportService.shouldRequestPermission(TargetPlatform.android),
        isTrue);
    expect(ContactImportService.shouldRequestPermission(TargetPlatform.iOS),
        isFalse);
    expect(ContactImportService.shouldRequestPermission(TargetPlatform.windows),
        isFalse);
  });
}
