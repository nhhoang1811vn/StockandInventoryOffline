import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

SnackBar snackBarWhenFailure(BuildContext context) {
  return SnackBar(
    content: Text(context.tr("snackbar_try_again")),
    backgroundColor: Colors.red,
  );
}

SnackBar snackBarWhenSuccess(BuildContext context) {
  return SnackBar(
    content: Text(context.tr("snackbar_saved")),
    backgroundColor: Colors.green,
  );
}

SnackBar snackBarWhenFailureWithText(String snackBarFailureText) {
  return SnackBar(
    content: Text(snackBarFailureText),
    backgroundColor: Colors.red,
  );
}

SnackBar snackBarWhenSuccessWithText(String text) {
  return SnackBar(
    content: Text(text),
    backgroundColor: Colors.green,
  );
}
