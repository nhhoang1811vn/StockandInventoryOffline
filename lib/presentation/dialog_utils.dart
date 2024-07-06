import 'package:flutter/material.dart';

class DialogUtils{
  static DialogUtils _instance = new DialogUtils.internal();
  DialogUtils.internal();
  factory DialogUtils() => _instance;
  static void showCustomDialog(BuildContext context,
      {required String title,
        String okBtnText = "Ok",
        required String message,
        String cancelBtnText = "",
        Function? okBtnFunction = null,
        Function? cancelBtnFunction = null,

      }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            if (cancelBtnText.isNotEmpty)
              TextButton(
                child: Text(cancelBtnText),
                onPressed: () {
                  if (cancelBtnFunction == null){
                    Navigator.of(context).pop();
                  }else{
                    cancelBtnFunction();
                  }
                }
              ),
            TextButton(
              child: Text(okBtnText),
              onPressed: () {
                if (okBtnFunction == null){
                  Navigator.of(context).pop();
                }else{
                  okBtnFunction();
                }
              },
            ),
          ],
        );
      },
    );
  }
}