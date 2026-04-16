import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/auth_listeners.dart';
import '../login/auth_cubit.dart';
import '../login/components/background.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool _emailValidate = false;
  var emailReg = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
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
                  "forget_password_title",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ).tr(),
                SizedBox(height: 32),
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
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (emailReg.hasMatch(emailController.text)) {
                        context.read<AuthCubit>().resetPassword(emailController.text);
                      } else {
                        setState(() {
                          _emailValidate =
                          !emailReg.hasMatch(emailController.text);
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
