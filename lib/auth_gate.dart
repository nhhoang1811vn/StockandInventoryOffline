import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_manager/presentation/pages/home/bloc/home_cubit.dart';
import 'package:good_manager/presentation/pages/home/home_page.dart';
import 'package:good_manager/presentation/pages/login/auth_cubit.dart';

import 'common/helpers/injection.container.dart';
import 'presentation/pages/login/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null){
      return BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: LoginScreen(),
      );
    }else{
      return BlocProvider(
          create: (context) => getIt<HomeCubit>(),
          child: HomePage());
    }
  }
}
