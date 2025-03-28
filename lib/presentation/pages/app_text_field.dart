import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class AppTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  String? initialValue;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTapped;
  bool? readOnly = false;
  final TextInputType keyboardType;
  final String? error;
  final TextEditingController? controller;
  List<TextInputFormatter>? inputFormatter = [];
  //Color color;
  String? suffixText;
  Widget? prefix;
  Widget? suffix;

  AppTextField(
      {Key? key,
      required this.labelText,
        required this.keyboardType,
      this.hintText = "",
      this.initialValue,
      this.onChanged,
      this.onTapped,
      this.readOnly = false,
      this.controller,
      this.error,
      //this.color = AppColors.secondaryColor,
      this.inputFormatter,
      this.suffixText,
        this.prefix,
        this.suffix
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
      borderRadius: BorderRadius.circular(8),
    );
    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0),
      borderRadius: BorderRadius.circular(8),
    );
    OutlineInputBorder enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 1.0),
      borderRadius: BorderRadius.circular(8),
    );
    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade700, width: 1.0),
      borderRadius: BorderRadius.circular(8),
    );

    return TextFormField(
      cursorColor: Colors.black,
      onTap: onTapped,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          border: border,
          prefix: prefix,
          suffix: suffix,
          suffixText: suffixText,
          disabledBorder: border,
          enabledBorder: enabledBorder,
          errorBorder: errorBorder,
          focusedBorder: focusedBorder,
          focusedErrorBorder: errorBorder,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorText: error,
          labelStyle: TextStyle(fontSize: 17, color: Colors.black),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 17, color: Colors.black)),
      autocorrect: false,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      onChanged: onChanged,
      readOnly: readOnly!,
      inputFormatters: inputFormatter,
      style: TextStyle(fontSize: 17, color: Colors.black),
    );
  }
}
