import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_wallet/views/HomeSection/bottom_navigation.dart';
import 'package:one_wallet/views/OnboardingProcess/log_in_screen.dart';
import 'package:one_wallet/views/ProfileSection/update_username.dart';

class FirebaseApi {
  FirebaseAuth instance = FirebaseAuth.instance;

  Future<void> signinWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await instance.signInWithEmailAndPassword(email: email, password: password);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.displayName != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigationScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const UpdateUsernameScreen(),
          ),
        );
      }
    }
  }

  static Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false);
  }
}
