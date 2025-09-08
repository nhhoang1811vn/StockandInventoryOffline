import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/auth_listeners.dart';
import '../login/auth_cubit.dart';
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

  bool _emailValidate = false;
  bool _passwordValidate = false;
  var emailReg = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

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
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "name".tr()),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  onChanged: (newText) {
                    setState(() {
                      _emailValidate = false;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "email".tr(),
                    errorText:
                    _emailValidate ? "error_invalid_email".tr() : null,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  onChanged: (newText) {
                    setState(() {
                      _passwordValidate = false;
                    });
                  },

                  decoration: InputDecoration(
                    labelText: "password".tr(),
                    errorText:
                    _passwordValidate
                        ? "error_invalid_password".tr()
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
                  obscureText: _obscurePassword,
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (emailReg.hasMatch(emailController.text) &&
                          passwordController.text.trim().isNotEmpty) {
                        context.read<AuthCubit>().linkWithEmail(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                        );
                      } else {
                        setState(() {
                          _emailValidate =
                          !emailReg.hasMatch(emailController.text);
                          _passwordValidate =
                              passwordController.text.trim().isEmpty;
                        });
                      }
                    },
                    child: const Text('next').tr(),
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
            icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
