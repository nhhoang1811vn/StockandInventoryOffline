import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/presentation/app_theme_builder.dart';

void main() {
  test('bottom sheets share the 22px top corners used by cards and sheets', () {
    for (final brightness in Brightness.values) {
      final shape = buildAppTheme(Colors.teal, brightness)
          .bottomSheetTheme
          .shape as RoundedRectangleBorder;
      expect(shape.borderRadius,
          const BorderRadius.vertical(top: Radius.circular(22)));
    }
  });
}
