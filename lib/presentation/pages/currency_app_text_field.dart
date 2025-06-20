import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_manager/presentation/pages/app_text_field.dart';

import 'currency_input_formatter.dart';

class CurrencyAppTextField extends StatelessWidget{
  final String labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final Widget? suffix;
  CurrencyAppTextField({
    Key? key,
    required this.labelText,
    this.controller,
    this.onChanged,
    this.readOnly = false,
    this.suffix
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
        hintText: "0",
        labelText: labelText,
        controller: controller,
        onChanged: onChanged,
        readOnly: readOnly,
        keyboardType: TextInputType.number,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          CurrencyInputFormatter()
        ],
        suffix: suffix,
    );
  }
}