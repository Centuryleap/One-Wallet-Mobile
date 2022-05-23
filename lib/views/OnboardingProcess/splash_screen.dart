/// A comment.
// 

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_wallet/views/HomeSection/bottom_navigation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_wallet/views/OnboardingProcess/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigateToHome();
    super.initState();
  }

  //this function is used to navigate to the appropriate screen after a period of time
  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 7000), () {});

    //this module is used to check if the user is logged in or not
    User? user = FirebaseAuth.instance.currentUser;

    //
    if (user != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BottomNavigationScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SvgPicture.asset(
          'assets/onboarding_screen_svg_black.svg',
          width: 223.w,
          height: 48.h,
        ),
      ),
    );
  }
}
