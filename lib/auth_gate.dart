import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/main.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/pages/home/bloc/loading_user_data_cubit.dart';
import 'package:good_manager/presentation/pages/home/home_page.dart';
import 'package:good_manager/presentation/pages/home/loading_user_data_widget.dart';
import 'package:good_manager/presentation/pages/login/auth_cubit.dart';

import 'common/helpers/injection.container.dart';
import 'presentation/pages/login/login_page.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
      return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return BlocProvider(
            create: (context) => getIt<AuthCubit>(),
            child: LoginScreen(),
          );
        }else{
          if (firstTimeLogin){
            return BlocProvider(
                create: (context) => getIt<LoadingUserDataCubit>(),
                child: LoadingUserDataWidget());
          }else{
            return BlocProvider(
                create: (context) => getIt<HomeCubit>(),
                child: HomePage());
          }
        }
      });
    }
  }
