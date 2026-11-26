import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import 'alert_dialog.dart';
import 'select_color_dialog.dart';
import 'select_option_dialog.dart';

bool isDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

void hideDialog(BuildContext context) {
  if (isDialogShowing(context)) {
    Navigator.pop(context);
  }
}

Future<void> showProgressIndicator(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Future<void> showSelectColorDialog(
  BuildContext context, {
  Color? barrierColor = Colors.black54,
  required Color? color,
  required Function(Color)? onItemSelected,
}) {
  return showDialogWithAnimation<void>(
    barrierColor: barrierColor,
    context: context,
    child: SelectColorDialog(
      color: color,
      onItemSelected: onItemSelected,
    ),
  );
}

Future<void> showBuySubscriptionDialog(
  BuildContext context, {
  Color? barrierColor = Colors.black54,
  required String message,
}) {
  return showCustomAlertDialog(
    context,
    title: context.tr("notification"),
    message: message,
    positiveText: context.tr("action_yes"),
    negativeText: context.tr("action_no"),
    onPositivePressed: () async {
      hideDialog(context);
      await RevenueCatUI.presentPaywall();
    },
    barrierColor: barrierColor,
  );
}

Future<void> showSelectOptionDialog(
  BuildContext context, {
  Color? barrierColor = Colors.black54,
  String? title,
  required List<String> items,
  required Function(int)? onItemSelected,
}) {
  return showDialogWithAnimation<void>(
    barrierColor: barrierColor,
    context: context,
    child: SelectOptionDialog(
      title: title,
      items: items,
      onItemSelected: onItemSelected,
    ),
  );
}

Future<void> showCustomAlertDialog(
  BuildContext context, {
  String? title,
  required String message,
  String? positiveText,
  String? negativeText,
  Function()? onNegativePressed,
  Function()? onPositivePressed,
  Color? barrierColor = Colors.black54,
  bool destructive = false,
}) {
  return showDialogWithAnimation<void>(
    barrierColor: barrierColor,
    context: context,
    child: CustomAlertDialog(
      destructive: destructive,
      title: title ?? context.tr("notification"),
      message: message,
      positiveText: positiveText ?? context.tr("ok"),
      negativeText: negativeText ?? context.tr("cancel"),
      onNegativePressed: onNegativePressed ??
          () {
            hideDialog(context);
          },
      onPositivePressed: onPositivePressed ??
          () {
            hideDialog(context);
          },
    ),
  );
}

void showCalculatorPopup(
  BuildContext context,
  double? value,
  Function(double) callback,
) async {
  var calc = SimpleCalculator(
    value: value ?? 0,
    onChanged: (key, value, expression) {
      if (value != null) {
        callback(value);
      }
    },
    theme: CalculatorThemeData(
//borderColor: Colors.black,
      borderWidth: 2,
//displayColor: Colors.black,
//displayStyle: TextStyle(fontSize: 80, color: Colors.yellow),
//expressionColor: Colors.indigo,
//expressionStyle: TextStyle(fontSize: 20, color: Colors.white),
      operatorColor: Theme.of(context).colorScheme.primary,
      operatorStyle: TextStyle(
        fontSize: 24,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      commandColor: Theme.of(context).colorScheme.primary,
      commandStyle: TextStyle(
        fontSize: 24,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
//numColor: Colors.grey,
//numStyle: TextStyle(fontSize: 50, color: Colors.white),
//equalColor: Colors.blue,
//equalStyle: TextStyle(fontSize: 50, color: Colors.black),
    ),
  );
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: calc,
      );
    },
  );
}

Future<T?> showDialogWithAnimation<T>({
  required BuildContext context,
  bool dismissible = true,
  Color? barrierColor = Colors.black54,
  required Widget child,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (
      BuildContext buildContext,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return Builder(
        builder: (BuildContext context) {
          return child;
        },
      );
    },
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? Colors.black54,
    transitionDuration: MediaQuery.maybeDisableAnimationsOf(context) == true
        ? Duration.zero
        : const Duration(milliseconds: 200),
    transitionBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}
