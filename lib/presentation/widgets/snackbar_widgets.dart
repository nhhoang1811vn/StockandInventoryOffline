import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


SnackBar snackBarWhenFailure(BuildContext context) {
  return SnackBar(
    content: Text(AppLocalizations.of(context)?.error ?? ""),
    backgroundColor: Colors.red,
  );
}
SnackBar snackBarWhenSuccess(BuildContext context) {
  return SnackBar(
    content: Text(AppLocalizations.of(context)?.success ?? ""),
    backgroundColor: Colors.green,
  );
}

SnackBar snackBarWhenFailureWithText(String snackBarFailureText) {
  return SnackBar(
    content: Text(snackBarFailureText),
    backgroundColor: Colors.red,
  );
}


SnackBar snackBarWhenSuccessWithText(String text){
  return SnackBar(
    content: Text(text),
    backgroundColor: Colors.green,
  );
}
