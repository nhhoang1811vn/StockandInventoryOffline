import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTapped;
  final bool? readOnly;
  final bool obscureText;
  final Widget? suffixIcon;

  final TextInputType keyboardType;
  final String? error;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatter;

  final String? suffixText;
  final Widget? prefix;
  final Widget? suffix;

  final int minLines;
  final int? maxLines;
  final TextInputAction textInputAction;

  const AppTextField({
    super.key,
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
    this.obscureText = false,
    this.suffixIcon,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// Several fields can gain an error in the same frame (submit with an
  /// invalid form). Only the first one, in tree order, scrolls into view.
  static bool _scrollScheduled = false;

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.error == null && widget.error != null && !_scrollScheduled) {
      _scrollScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollScheduled = false;
        if (!mounted) return;
        Scrollable.ensureVisible(
          context,
          alignment: 0.2,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTapped,
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      keyboardType: widget.keyboardType,
      minLines: widget.obscureText ? 1 : widget.minLines,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      obscureText: widget.obscureText,
      // Borders, focus and error colors come from inputDecorationTheme.
      decoration: InputDecoration(
        prefix: widget.prefix,
        suffix: widget.suffix,
        suffixIcon: widget.suffixIcon,
        suffixText: widget.suffixText,
        labelText: widget.labelText,
        errorText: widget.error,
        hintText: widget.hintText,
      ),
      autocorrect: false,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly!,
      inputFormatters: widget.inputFormatter,
    );
  }
}
