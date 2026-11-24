import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_manager/util/quantity_format.dart';

TextEditingValue _v(String text) => TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );

String _apply(QuantityInputFormatter f, String oldText, String newText) =>
    f.formatEditUpdate(_v(oldText), _v(newText)).text;

void main() {
  group('formatQuantity', () {
    test('rounds to N digits and drops trailing zeros', () {
      expect(formatQuantity(5.12, 2), '5.12');
      expect(formatQuantity(5.0, 2), '5');
      expect(formatQuantity(5.2, 2), '5.2');
      expect(formatQuantity(5.126, 2), '5.13');
      expect(formatQuantity(2.5, 0), '3');
      expect(formatQuantity(100.0, 2), '100');
      expect(formatQuantity(10.50, 1), '10.5');
    });

    test('never shows "-0" and keeps real negatives', () {
      expect(formatQuantity(-0.001, 2), '0');
      expect(formatQuantity(-2.5, 1), '-2.5');
    });

    test('groups the integer part only when asked', () {
      expect(formatQuantity(1234.5, 2, grouping: true), '1,234.5');
      expect(formatQuantity(1234567.0, 0, grouping: true), '1,234,567');
      expect(formatQuantity(1234.5, 2), '1234.5');
      expect(formatQuantity(-1234.5, 2, grouping: true), '-1,234.5');
    });
  });

  group('roundQuantity', () {
    test('rounds to N digits', () {
      expect(roundQuantity(5.126, 2), 5.13);
      expect(roundQuantity(2.4, 0), 2.0);
    });
  });

  group('QuantityInputFormatter', () {
    final two = QuantityInputFormatter(2);

    test('accepts partial and complete numbers within N decimals', () {
      for (final t in ['', '5', '5.', '.5', '5.12']) {
        expect(_apply(two, 'x', t), t, reason: t);
      }
    });

    test('rejects extra decimals, second dot, letters and minus', () {
      expect(_apply(two, '5.12', '5.123'), '5.12');
      expect(_apply(two, '5', '5..1'), '5');
      expect(_apply(two, '5.1', '5.1.2'), '5.1');
      expect(_apply(two, '5', '5a'), '5');
      expect(_apply(two, '', '-1'), '');
    });

    test('rejects a pasted number with too many decimals', () {
      expect(_apply(two, '', '1.234'), '');
    });

    test('with 0 digits only whole numbers are accepted', () {
      final zero = QuantityInputFormatter(0);
      expect(_apply(zero, '1', '12'), '12');
      expect(_apply(zero, '12', '12.'), '12');
    });
  });
  group('review fixes', () {
    final two = QuantityInputFormatter(2);

    test('text the formatter would not accept can still be deleted', () {
      expect(_apply(two, '-3', '-'), '-');
      expect(_apply(two, '-', ''), '');
      expect(_apply(two, 'NaN', 'Na'), 'Na');
      // but nothing new can be added to it
      expect(_apply(two, '-3', '-35'), '-3');
    });

    test('a decimal comma is typed as a dot', () {
      expect(_apply(two, '5', '5,'), '5.');
      expect(_apply(two, '', '2,5'), '2.5');
      expect(_apply(QuantityInputFormatter(0), '1', '1,'), '1');
      expect(_apply(two, '5,1', '5,12'), '5.12');
    });

    test('calculatorQuantityText rounds and never yields NaN or Infinity', () {
      expect(calculatorQuantityText(2.456, 2), '2.46');
      expect(calculatorQuantityText(2.5, 0), '3');
      expect(calculatorQuantityText(double.nan, 2), '0');
      expect(calculatorQuantityText(double.infinity, 2), '0');
      expect(calculatorQuantityText(double.negativeInfinity, 2), '0');
    });

    test('quantityTextMatches compares the typed text with the value', () {
      expect(quantityTextMatches('2.', 2.0), isTrue);
      expect(quantityTextMatches('2.50', 2.5), isTrue);
      expect(quantityTextMatches('', null), isTrue);
      expect(quantityTextMatches('abc', null), isTrue);
      expect(quantityTextMatches('2.', 2.5), isFalse);
      expect(quantityTextMatches('', 2.0), isFalse);
    });

    test('signedQuantityText never shows a signed zero', () {
      expect(signedQuantityText(1.5, 2, incoming: true), '+1.5');
      expect(signedQuantityText(1.5, 2, incoming: false), '-1.5');
      expect(signedQuantityText(0.4, 0, incoming: false), '0');
      expect(signedQuantityText(0.004, 2, incoming: true), '0');
    });
  });
}
