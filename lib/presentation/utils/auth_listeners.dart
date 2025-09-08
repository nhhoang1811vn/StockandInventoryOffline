import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/main.dart';

import '../../util/toast_utils.dart';
import '../dialog/custom_dialog.dart';
import '../pages/login/auth_cubit.dart';
import '../pages/pages.dart';

void authStateListener(BuildContext context, AuthState state) {
  if (state is AuthLoading) {
    showProgressIndicator(context);
  } else if (state is AuthError) {
    Navigator.of(context).pop();
    ToastUtils.showInfoToast(state.message);
  } else if (state is AuthStopped) {
    Navigator.of(context).pop();
  } else if (state is ResetPasswordSent) {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    ToastUtils.showInfoToast("reset_password_successful_message".tr());
  } else if (state is UserLinkSuccessful) {
    Navigator.of(context).pushNamedAndRemoveUntil(Pages.main, (route) => false);
  } else if (state is UserSignIn){
    Navigator.of(context).pop();
    justLogin = true;
    Navigator.of(context).pushNamedAndRemoveUntil(Pages.loading_data, (route) => false);
  }
}
