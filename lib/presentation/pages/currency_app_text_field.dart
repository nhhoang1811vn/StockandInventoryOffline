import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';

import 'currency_input_formatter.dart';

class CurrencyAppTextField extends StatelessWidget{
  final String labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  bool? readOnly = false;
  /*String? initialValue;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTapped;
  bool? readOnly = false;
  final TextInputType keyboardType;
  final String? error;
  final TextEditingController? controller;
  List<TextInputFormatter>? inputFormatter = [];
  Color color;
  bool currency = false;
  AppTextField({
    Key? key,
    required this.labelText,
    this.initialValue,
    this.onChanged,
    this.onTapped,
    this.readOnly = false,
    this.controller,
    required this.keyboardType,
    this.error,
    this.color = AppColors.secondaryColor,
    this.inputFormatter,
    this.currency = false
  }) : super(key: key);*/
  CurrencyAppTextField({
    Key? key,
    required this.labelText,
    this.controller,
    this.onChanged,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*UnderlineInputBorder border =
    UnderlineInputBorder(borderSide: BorderSide(color: color, width: 1));
    UnderlineInputBorder errorBorder =
    const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent, width: 1));*/

    /*return TextFormField(
      cursorColor: color,
      onTap: onTapped,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: border,
        suffixText: currency?"đ":"",
        disabledBorder: border,
        enabledBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        labelText: labelText,
        errorText: error,
        labelStyle: TextStyle(fontSize: 18, color: color)
      ),
      autocorrect: false,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      onChanged: onChanged,
      readOnly: readOnly!,
      inputFormatters: inputFormatter,
      style: TextStyle(fontSize: 18, color: color),
    );*/
    return AppTextField(
        labelText: labelText,
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly!,
        suffixText: "đ",
        keyboardType: TextInputType.number,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          CurrencyInputFormatter()
        ],
    );
  }
}