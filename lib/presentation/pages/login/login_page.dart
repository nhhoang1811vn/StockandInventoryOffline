import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:good_manager/common/platform_support.dart';
import 'package:good_manager/presentation/widget/app_text_field.dart';
import 'package:good_manager/presentation/widget/primary_button.dart';

import '../../utils/auth_listeners.dart';
import '../pages.dart';
import 'auth_cubit.dart';
import 'auth_input.dart';
import 'components/background.dart';
import 'social_button_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _emailValidate = false;
  bool _passwordValidate = false;

  @override
  void dispose() {
    super.dispose();
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
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        buildWhen: (previous, current) => previous != current,
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          authStateListener(context, state);
        },
        builder: (context, state) {
          return _buildPage(context);
        },
      ),
    );
  }
  bool _obscurePassword = true;
  Widget _buildPage(BuildContext context) {
    return Stack(
      children: [
        Background(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 32),
                Text(
                  "login_with_email",
                  style: Theme.of(context).textTheme.titleLarge,
                ).tr(),
                SizedBox(height: 32),
                AppTextField(
                  labelText: "email".tr(),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  onChanged: (newText) {
                    setState(() {
                      _emailValidate = false;
                    });
                  },
                  error: _emailValidate ? "error_invalid_email".tr() : null,
                ),
                SizedBox(height: 16),
                AppTextField(
                  labelText: "password".tr(),
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscurePassword,
                  onChanged: (newText) {
                    setState(() {
                      _passwordValidate = false;
                    });
                  },
                  error: _passwordValidate
                      ? "error_password_too_short".tr()
                      : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(Pages.forgotPassword);
                  },
                  child: Text(
                    "forget_password".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    context.tr("login"),
                    () {
                      final emailOk =
                          AuthInput.isValidEmail(emailController.text);
                      final passwordOk =
                          AuthInput.isValidPassword(passwordController.text);
                      if (emailOk && passwordOk) {
                        context.read<AuthCubit>().signInWithEmail(
                              emailController.text.trim(),
                              passwordController.text,
                        );
                      } else {
                        setState(() {
                          _emailValidate = !emailOk;
                          _passwordValidate = !passwordOk;
                        });
                      }
                    },
                  ),
                ),
                if (isMobilePlatform) ...[
                  SizedBox(height: 32),
                  _buildLoginWithGoogle(),
                  SizedBox(height: 16),
                  _buildLoginWithApple(),
                ],
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginWithGoogle() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: socialAuthButtonStyle(context, backgroundColor: Colors.white),
        icon: SvgPicture.asset('assets/svgs/google.svg', width: 24, height: 24),
        label:
        const Text(
          'login_with_google',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ).tr(),
        onPressed: () {
          context.read<AuthCubit>().signInWithGoogle();
        },
      ),
    );
  }

  Widget _buildLoginWithApple() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: socialAuthButtonStyle(context, backgroundColor: Colors.black),
        icon: SvgPicture.asset(
          'assets/svgs/apple_logo.svg',
          width: 24,
          height: 24,
        ),
        label:
        const Text('login_with_apple', style: TextStyle(fontSize: 16,  color: Colors.white)).tr(),
        onPressed: () {
          context.read<AuthCubit>().signInWithApple();
        },
      ),
    );
  }
}
