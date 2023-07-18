import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget{
  final String labelText;
  String? initialValue;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTapped;
  bool? readOnly = false;
  final TextInputType keyboardType;
  final String? error;
  final TextEditingController? controller;

  AppTextField({
    Key? key,
    required this.labelText,
    this.initialValue,
    this.onChanged,
    this.onTapped,
    this.readOnly = false,
    this.controller,
    required this.keyboardType,
    this.error
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //UnderlineInputBorder border =
    //const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent, width: 2));
    UnderlineInputBorder errorBorder =
    const UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent, width: 2));

    return TextFormField(
      onTap: onTapped,
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        //border: border,
        //disabledBorder: border,
        //enabledBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        labelText: labelText,
        errorText: error,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      onChanged: onChanged,
      readOnly: readOnly!,
      //validator: (_) => error,
    );
  }
}