import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/l10n/app_localizations.dart';
import 'package:good_manager/presentation/pages/login/auth_cubit.dart';
import 'package:good_manager/presentation/pages/login/components/background.dart';

import '../../dialog/dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _signupPage(context));
  }

  Widget _signupPage(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) async {
        if (state is AuthLoading) {
          showProgressIndicator(context);
        } else if (state is AuthError) {
          Navigator.of(context).pop();
          String title =
              'Error'; //AppLocalizations.of(context)!.notification_dialog_title;
          String message = state.message;
          showCustomAlertDialog(
            context,
            title: title,
            message: message,
          );
        } else if (state is UserSingupButNotVerified) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Background(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    AppLocalizations.of(context)!.sign_up,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.name,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.email,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.password,
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().signUpWithEmail(
                            nameController.text,
                            emailController.text,
                            passwordController.text,
                          );
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
                        gradient: new LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 136, 34),
                            Color.fromARGB(255, 255, 177, 41),
                          ],
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.sign_up,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
                          Text(
                            "Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
