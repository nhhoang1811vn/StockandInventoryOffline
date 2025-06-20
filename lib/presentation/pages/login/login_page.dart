import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/dialog_utils.dart';
import 'package:good_manager/presentation/pages/login/components/background.dart';
import 'package:good_manager/presentation/pages/login/components/do_not_have_account.dart';
import 'package:good_manager/presentation/pages/login/components/sign_in_with_google_text.dart';
import 'package:good_manager/presentation/pages/pages.dart';

import '../../widgets/progress_indicaror.dart';
import 'auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnonymous = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _emailValidate = false;
  bool _passwordValidate = false;
  var emailReg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _loginPage(context));
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context);
    _isAnonymous = FirebaseAuth.instance.currentUser?.isAnonymous ?? false;
  }

  Widget _loginPage(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) async {
        if (state is AuthLoading) {
          ProgressIndicaror.showProgressIndicator(context);
        } else if (state is AuthError) {
          Navigator.of(context).pop();
          String title =
              AppLocalizations.of(context)!.notification_dialog_title;
          String message = state.message;
          if (message.contains("The supplied auth credential is incorrect")) {
            DialogUtils.showCustomDialog(context,
                title: title,
                message:
                    AppLocalizations.of(context)!.error_wrong_email_password);
          } else {
            DialogUtils.showCustomDialog(context,
                title: title, message: message);
          }
        }
        else if (state is UserSignIn) {
          Navigator.of(context).popAndPushNamed(Pages.loading_data);
        } else if (state is UserNotVerified) {
          Navigator.of(context).pop();
          String title = AppLocalizations.of(context)!.email_not_verified_title;
          String message =
              AppLocalizations.of(context)!.email_not_verified_desc;
          DialogUtils.showCustomDialog(context, title: title, message: message);
        } else if (state is IsNewUser) {
        } else if (state is AuthStopped) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Background(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      !_isAnonymous ? AppLocalizations.of(context)!.login : AppLocalizations.of(context)!.menu_item_upgrade_account,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA),
                          fontSize: 36),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: emailController,
                      onChanged: (newText) {
                        setState(() {
                          _emailValidate = false;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.email,
                          errorText: _emailValidate
                              ? AppLocalizations.of(context)!.error_email
                              : null),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: passwordController,
                      onChanged: (newText) {
                        setState(() {
                          _passwordValidate = false;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.password,
                          errorText: _passwordValidate
                              ? AppLocalizations.of(context)!.error_password
                              : null),
                      obscureText: true,
                    ),
                  ),
                  if (!_isAnonymous)
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Pages.forgotPassword);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgot_your_password,
                        style: TextStyle(color: Color(0XFF2661FA)),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (emailReg.hasMatch(emailController.text) &&
                            passwordController.text.trim().isNotEmpty) {
                          justLogin = true;
                          context.read<AuthCubit>().signInWithEmail(
                              emailController.text, passwordController.text);
                        } else {
                          setState(() {
                            _emailValidate =
                                !emailReg.hasMatch(emailController.text);
                            _passwordValidate =
                                passwordController.text.trim().isEmpty;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            gradient: new LinearGradient(colors: [
                              Color.fromARGB(255, 255, 136, 34),
                              Color.fromARGB(255, 255, 177, 41)
                            ])),
                        child: Text(
                          !_isAnonymous ? AppLocalizations.of(context)!.login : AppLocalizations.of(context)!.menu_item_upgrade_account,
                          //AppLocalizations.of(context)!.login,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: SigninWithGoogleText()),

                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        justLogin = true;
                        context.read<AuthCubit>().signInWithGoogle();
                        // if (Platform.isWindows) {
                        //   context
                        //       .read<AuthCubit>()
                        //       .signInWithGoogleInWindowPlatform();
                        // } else {
                        //   context.read<AuthCubit>().signInWithGoogle();
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          color: Colors.blue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: SvgPicture.asset(
                                  'assets/svgs/google_icon2.svg',
                                  height: 24,
                                  width: 24,
                                )),
                            SizedBox(width: 16),
                            Text(
                              "Continue with Google",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        justLogin = true;
                        context.read<AuthCubit>().signInWithApple();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width,
                        decoration: new BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(80.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/apple_logo.svg',
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(width: 16),
                            Text(
                              "Continue with Apple",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!_isAnonymous)
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        //justLogin = true;
                        context.read<AuthCubit>().signInWithGuest();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width,
                        decoration: new BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(80.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SvgPicture.asset(
                            //   'assets/svgs/apple_logo.svg',
                            //   height: 24,
                            //   width: 24,
                            // ),
                            // SizedBox(width: 16),
                            Text(
                              "Continue with Guest",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!_isAnonymous)
                  Container(
                      alignment: Alignment.centerRight,
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: DoNotHaveAccountText())
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
