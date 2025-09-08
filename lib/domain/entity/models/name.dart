import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

// Define input validation errors
enum NameInputError { empty }

// Extend FormzInput and provide the input type and error type.
class NameInput extends FormzInput<String, NameInputError> {
  // Call super.pure to represent an unmodified form input.
  const NameInput.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const NameInput.dirty({String value = ''}) : super.dirty(value);

  // Override validator to handle validating a given input value.
  @override
  NameInputError? validator(String value) {
    return value.isEmpty ? NameInputError.empty : null;
  }
}

extension NameInputErrorExtension on NameInputError {
  String text(BuildContext context) {
    switch (this) {
      case NameInputError.empty:
        return context.tr("error_field_name_empty");
    }
  }
}
