import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/widget/app_text_field.dart';
import 'package:good_manager/presentation/widget/primary_button.dart';

import '../../utils/auth_listeners.dart';
import '../login/auth_cubit.dart';
import '../login/auth_input.dart';
import '../login/components/background.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _nameValidate = false;
  bool _emailValidate = false;
  bool _passwordValidate = false;

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
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        buildWhen: (previous, current) => previous != current,
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          authStateListener(context, state);
        },
        builder: (context, state) {
          return buildPage(context);
        },
      ),
    );
  }
  bool _obscurePassword = true;
  Widget buildPage(BuildContext context) {
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
                  "sign_up_with_email",
                  style: Theme.of(context).textTheme.titleLarge,
                ).tr(),
                SizedBox(height: 32),
                AppTextField(
                  labelText: "name".tr(),
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    setState(() {
                      _nameValidate = false;
                    });
                  },
                  error: _nameValidate ? "error_name_required".tr() : null,
                ),
                SizedBox(height: 16),
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
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    context.tr("sign_up"),
                    () {
                      final nameOk = nameController.text.trim().isNotEmpty;
                      final emailOk =
                          AuthInput.isValidEmail(emailController.text);
                      final passwordOk =
                          AuthInput.isValidPassword(passwordController.text);
                      if (nameOk && emailOk && passwordOk) {
                        context.read<AuthCubit>().linkWithEmail(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text,
                        );
                      } else {
                        setState(() {
                          _nameValidate = !nameOk;
                          _emailValidate = !emailOk;
                          _passwordValidate = !passwordOk;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: IconButton(
            tooltip: context.tr('action_back'),
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
