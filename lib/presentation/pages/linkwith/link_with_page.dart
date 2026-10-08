import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:good_manager/presentation/pages/pages.dart';

import '../../utils/auth_listeners.dart';
import '../login/auth_cubit.dart';
import '../login/components/background.dart';
import '../login/social_button_style.dart';

class LinkWithPage extends StatefulWidget {
  const LinkWithPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LinkWithPageState();
  }
}

class LinkWithPageState extends State<LinkWithPage> {
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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context);
  }

  Widget _buildPage(BuildContext context) {
    return Stack(
      children: [
        Background(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
                  "link_with_title",
                  style: Theme.of(context).textTheme.titleLarge,
                ).tr(),
                SizedBox(height: 8),
                Text(
                  "link_with_desc",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ).tr(),
                SizedBox(height: 32),
                _buildContinueWithGoogle(),
                SizedBox(height: 16),
                //if (Platform.isIOS)
                _buildContinueWithApple(),
                SizedBox(height: 16),
                _buildContinueWithEmail(),
                SizedBox(height: 64),
                _buildAlreadyHaveAnAccount(),
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

  Widget _buildContinueWithGoogle() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: socialAuthButtonStyle(context, backgroundColor: Colors.white),
        icon: SvgPicture.asset('assets/svgs/google.svg', width: 24, height: 24),
        label:
            const Text(
              'continue_with_google',
              style: TextStyle(fontSize: 16, color: Colors.black),

            ).tr(),
        onPressed: () {
          context.read<AuthCubit>().linkWithGoogle();
        },
      ),
    );
  }

  Widget _buildContinueWithApple() {
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
            const Text(
              'continue_with_apple',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ).tr(),
        onPressed: () {
          context.read<AuthCubit>().linkWithApple();
        },
      ),
    );
  }

  Widget _buildContinueWithEmail() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: socialAuthButtonStyle(context, backgroundColor: Colors.white),
        icon: Icon(Icons.email, size: 24, color: Colors.black),
        label:
            const Text(
              'continue_with_email',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ).tr(),
        onPressed: () {
          Navigator.of(context).pushNamed(Pages.signup);
        },
      ),
    );
  }

  Widget _buildAlreadyHaveAnAccount() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(Pages.signIn);
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "already_have_an_account".tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextSpan(
              text: "login".tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
