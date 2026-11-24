import 'package:flutter/services.dart';

/// Quantity text with at most [decimals] digits after the decimal point: the
/// value is rounded, then trailing zeros (and a trailing dot) are dropped, so
/// with 2 digits 5.12 → "5.12", 5.00 → "5", 5.20 → "5.2". A rounded zero is
/// always "0" (never "-0"). With [grouping] the integer part gets thousands
/// separators ("1,234.5").
String formatQuantity(double value, int decimals, {bool grouping = false}) {
  var text = value.toStringAsFixed(decimals);
  if (decimals > 0 && text.contains('.')) {
    text =
        text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
  if (text == '-0') text = '0';
  if (!grouping) return text;

  final negative = text.startsWith('-');
  final unsigned = negative ? text.substring(1) : text;
  final dot = unsigned.indexOf('.');
  final integer = dot < 0 ? unsigned : unsigned.substring(0, dot);
  final fraction = dot < 0 ? '' : unsigned.substring(dot);
  final grouped = integer.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '${negative ? '-' : ''}$grouped$fraction';
}

/// [value] rounded to [decimals] digits after the decimal point.
double roundQuantity(double value, int decimals) =>
    double.parse(value.toStringAsFixed(decimals));

/// Lets a quantity text field hold only digits and one ".", with at most
/// [decimals] digits after it (whole numbers only when it is 0). Anything else
/// leaves the text as it was.
class QuantityInputFormatter extends TextInputFormatter {
  final RegExp _pattern;

  QuantityInputFormatter(int decimals)
      : _pattern = decimals <= 0
            ? RegExp(r'^\d*$')
            : RegExp('^\\d*\\.?\\d{0,$decimals}\$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // A decimal comma (some regional keyboards) is typed as a dot.
    final text = newValue.text.replaceAll(',', '.');
    final value =
        text == newValue.text ? newValue : newValue.copyWith(text: text);
    if (_pattern.hasMatch(text)) return value;
    // Text set from code that the pattern would reject (a calculator result)
    // must still be deletable.
    if (!_pattern.hasMatch(oldValue.text) &&
        newValue.text.length < oldValue.text.length) {
      return newValue;
    }
    return oldValue;
  }
}

/// A calculator result as text for a quantity field: rounded to [decimals],
/// and "0" when it is not a finite number (for example a division by zero).
String calculatorQuantityText(double value, int decimals) => value.isFinite
    ? formatQuantity(roundQuantity(value, decimals), decimals)
    : formatQuantity(0, decimals);

/// Whether the text typed in a quantity field already stands for [value]
/// (so the field need not be rewritten, which would drop a trailing ".").
bool quantityTextMatches(String text, double? value) =>
    double.tryParse(text) == value;

/// "+1.5" / "-1.5" for a history row; a rounded zero has no sign.
String signedQuantityText(double quantity, int decimals,
    {required bool incoming}) {
  final text = formatQuantity(quantity, decimals);
  if (text == '0') return text;
  return '${incoming ? '+' : '-'}$text';
}
