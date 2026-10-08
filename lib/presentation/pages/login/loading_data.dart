import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/pages/login/auth_cubit.dart';
import 'package:good_manager/presentation/pages/pages.dart';

class LoadingData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoadingDataState();
  }
}

class LoadingDataState extends State<LoadingData> {
  @override
  void initState() {
    super.initState();
    if (justLogin) {
      context.read<AuthCubit>().downloadUserData();
    } else {
      context.read<AuthCubit>().checkStore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is UserSignInSuccessfulWithStore) {
          if (!context.mounted) return;
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Pages.main, (route) => false);
        } else if (state is UserSignInSuccessfulWithNoStore) {
          if (!context.mounted) return;
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Pages.onboarding, (route) => false);
        }
      },
      builder: (context, state) {
        if (state is StartupFailure) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off_outlined,
                      size: 64,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (justLogin) {
                            context.read<AuthCubit>().downloadUserData();
                          } else {
                            context.read<AuthCubit>().checkStore();
                          }
                        },
                        child: Text(context.tr("startup_retry")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/app_logo.png'),
                  width: 80,
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 16),
                Text(context.tr("loading_data")),
              ],
            ),
          ),
        );
      },
    );
  }
}
