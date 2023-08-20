import 'package:flutter/services.dart';
import 'package:good_manager/presentation/constants.dart';

class CurrencyInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.selection.baseOffset == 0){
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);
    //currencyFormat
    //final formatter =  NumberFormat.currency(locale: "vi_VN", symbol: "");

    String newText = Config.simpleCurrencyFormat.format(value);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}