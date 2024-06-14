import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/dialog_utils.dart';
import 'package:good_manager/presentation/pages/login/components/background.dart';
import 'package:good_manager/presentation/pages/login/components/do_not_have_account.dart';
import 'package:good_manager/presentation/pages/login/components/no_internet.dart';
import 'package:good_manager/presentation/pages/login/components/sign_in_with_google_text.dart';
import 'package:good_manager/presentation/pages/pages.dart';
import 'package:good_manager/presentation/widgets/progress_indicaror.dart';

import 'auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bool firstTime = storage.getFirstTime();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return connected ? _loginPage(context) : const BuildNoInternet();
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context);
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
          String title = 'Error';//AppLocalizations.of(context)!.notification_dialog_title;
          String message = state.message;
          DialogUtils.showCustomDialog(context, title: title, message: message);
        } else if (state is UserSignIn) {
          final checkStores = await context.read<AuthCubit>().checkStore();
          if (checkStores){
            //there is store
            await context.read<AuthCubit>().updateSelectedStore();
            Navigator.of(context).pushNamedAndRemoveUntil(Pages.home, (route) => false);
          }else{
            //there is no store
            //go to onboard flow to create first store
            Navigator.of(context).pushNamedAndRemoveUntil(Pages.onboarding, (route) => false);
          }

          /*riveHelper.addSuccessController();
        await Future.delayed(const Duration(seconds: 2));
        riveHelper.dispose();*/
        /*
        if (!context.mounted) return;
        context.pushNamedAndRemoveUntil(
          Routes.homeScreen,
          predicate: (route) => false,
        );*/
        } else if (state is UserNotVerified) {
          Navigator.of(context).pop();
          String title = AppLocalizations.of(context)!.email_not_verified_title;
          String message = AppLocalizations.of(context)!.email_not_verified_desc;
          DialogUtils.showCustomDialog(context, title: title, message: message);
        } else if (state is IsNewUser) {
          /*context.pushNamedAndRemoveUntil(
          Routes.createPassword,
          predicate: (route) => false,
          arguments: [state.googleUser, state.credential],
        );*/
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
                        AppLocalizations.of(context)!.login,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2661FA), fontSize: 36),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password,),
                      obscureText: true,
                    ),
                  ),
              
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: GestureDetector(
                      onTap: (){
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
                        context.read<AuthCubit>().signInWithEmail(emailController.text, passwordController.text);
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
                            AppLocalizations.of(context)!.login,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Container(margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10), child: SigninWithGoogleText()),
                  InkWell(
                    radius: 50,
                    onTap: () {
                      context.read<AuthCubit>().signInWithGoogle();
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/google_logo.svg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: DoNotHaveAccountText()
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
