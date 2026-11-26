import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/pages.dart';

import 'bloc/startup_cubit.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    context.read<StartupCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartupCubit, StartupState>(
      buildWhen: (previous, current) => previous != current,
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (!context.mounted) return;
        if (state is StartupHasStore) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Pages.main, (route) => false);
        } else if (state is StartupNoStore) {
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
                        onPressed: () => context.read<StartupCubit>().load(),
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
                const Image(
                  image: AssetImage('assets/images/app_logo.png'),
                  width: 80,
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 16),
                Text(context.tr("loading_data")),
              ],
            ),
          ),
        );
      },
    );
  }
}
