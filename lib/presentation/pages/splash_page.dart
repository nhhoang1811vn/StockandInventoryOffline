import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_manager/presentation/pages/pages.dart';

import '../../revenuecat_purchase_manager.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //_checkAuthAndNavigate();
  }

  // Future<void> _checkAuthAndNavigate() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     await RevenueCatService.logoutUser();
  //     Navigator.pushReplacementNamed(context, Pages.signIn);
  //   } else {
  //     await RevenueCatService.updateUser(user.uid);
  //     Navigator.pushReplacementNamed(context, Pages.loading_data);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}