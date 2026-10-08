import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_manager/presentation/widget/app_text_field.dart';

class DoubleAppTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final Widget? suffix;

  DoubleAppTextField({
    Key? key,
    required this.labelText,
    this.controller,
    this.onChanged,
    this.readOnly = false,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      labelText: labelText,
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatter: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      suffix: suffix,
    );
  }
}
