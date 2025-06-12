import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  int minLines;
  int? maxLines;

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
      this.inputFormatter,
      this.suffixText,
        this.prefix,
        this.suffix,
        this.minLines = 1,
        this.maxLines = 1
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    final borderColor = isDark ? Colors.white70 : Colors.black;
    //final textColor = isDark ? Colors.white : Colors.black;
    //final hintColor = isDark ? Colors.white54 : Colors.black54;

    OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1.0),
      borderRadius: BorderRadius.circular(8),
    );
    OutlineInputBorder errorBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0),
      borderRadius: BorderRadius.circular(8),
    );
    OutlineInputBorder enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(color: borderColor , width: 1.0),
      borderRadius: BorderRadius.circular(8),
    );
    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue.shade700, width: 1.0),
      borderRadius: BorderRadius.circular(8),
    );

    return TextFormField(
      //cursorColor: Colors.black,
      onTap: onTapped,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
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
          //labelStyle: TextStyle(fontSize: 17, color: Colors.black),
          hintText: hintText,
          //hintStyle: TextStyle(fontSize: 17, color: Colors.black)
        ),
      autocorrect: false,
      textInputAction: TextInputAction.done,

      onChanged: onChanged,
      readOnly: readOnly!,
      inputFormatters: inputFormatter,
      //style: TextStyle(fontSize: 17, color: Colors.black),
    );
  }
}
