import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:good_manager/presentation/dialog_utils.dart';
import 'package:good_manager/presentation/pages/base/base_state_widget.dart';
import 'package:good_manager/presentation/pages/login/auth_cubit.dart';
import 'package:good_manager/presentation/pages/login/components/background.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/widgets/progress_indicaror.dart';

import '../login/components/no_internet.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends BaseStateWidget<SignUpScreen> {
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
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected ? _signupPage(context) : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
  Widget _signupPage(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return BlocConsumer<AuthCubit, AuthState>(
        buildWhen: (previous, current) => previous != current,
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is AuthLoading) {
            ProgressIndicaror.showProgressIndicator(context);
          } else if (state is AuthError) {
            Navigator.of(context).pop();
            String title = 'Error';//AppLocalizations.of(context)!.notification_dialog_title;
            String message = state.message;
            DialogUtils.showCustomDialog(context, title: title, message: message);

          }else if (state is UserSingupButNotVerified) {
            Navigator.of(context).pop();
            String title =  AppLocalizations.of(context)!.sign_up_successful; //'Sign up Success';
            String message = AppLocalizations.of(context)!.email_not_verified_desc;
            DialogUtils.showCustomDialog(context, title: title, message: message, okBtnFunction: (){
              Navigator.of(context).pushNamedAndRemoveUntil(Pages.signIn, (route) => false);
            });
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
                          fontSize: 36
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
                            nameController.text, emailController.text, passwordController.text);
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
                                colors: [Color.fromARGB(255, 255, 136, 34), Color.fromARGB(255, 255, 177, 41)])),
                        child: Text(
                          AppLocalizations.of(context)!.sign_up,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}