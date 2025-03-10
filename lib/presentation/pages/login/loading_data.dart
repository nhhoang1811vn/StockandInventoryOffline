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
            //Navigator.of(context)
            //    .pushNamedAndRemoveUntil(Pages.home, (route) => false);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Pages.main, (route) => false);

          } else if (state is UserSignInSuccessfulWithNoStore) {
            if (!context.mounted) return;
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Pages.onboarding, (route) => false);
          }
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Image(image: AssetImage('assets/images/app_icon.png'), width: 80,),
                        SizedBox(height: 16),
                    SizedBox(width: 24,height: 24,child: CircularProgressIndicator())
                  ])));
        });
  }
}
