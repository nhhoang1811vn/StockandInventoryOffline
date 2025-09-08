import 'package:flutter/services.dart';

import '../constant/constant.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }
    double value = double.parse(newValue.text);
    String newText = Config.simpleCurrencyFormat.format(value);
    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}
