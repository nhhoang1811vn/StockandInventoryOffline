import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTapped;
  final bool? readOnly;

  final TextInputType keyboardType;
  final String? error;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatter;

  //Color color;
  final String? suffixText;
  final Widget? prefix;
  final Widget? suffix;

  final int minLines;
  final int? maxLines;
  final TextInputAction textInputAction;

  AppTextField({
    Key? key,
    required this.labelText,
    required this.keyboardType,
    this.hintText = "",
    this.initialValue,
    this.onChanged,
    this.onTapped,
    this.readOnly = false,
    this.controller,
    this.error,
    this.inputFormatter,
    this.suffixText,
    this.prefix,
    this.suffix,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
  }) : super(key: key);

  OutlineInputBorder border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.0),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white70 : Colors.black;
    return TextFormField(
      onTap: onTapped,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: border(borderColor),
        prefix: prefix,
        suffix: suffix,
        suffixText: suffixText,
        disabledBorder: border(borderColor),
        enabledBorder: border(borderColor),
        errorBorder: border(Colors.red),
        focusedBorder: border(Colors.blue.shade700),
        focusedErrorBorder: border(Colors.red),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorText: error,
        hintText: hintText,
      ),
      autocorrect: false,
      textInputAction: textInputAction,

      onChanged: onChanged,
      readOnly: readOnly!,
      inputFormatters: inputFormatter,
      //style: TextStyle(fontSize: 17, color: Colors.black),
    );
  }
}
