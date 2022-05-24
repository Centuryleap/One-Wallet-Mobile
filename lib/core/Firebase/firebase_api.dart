import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_wallet/app/utils/utils.dart';
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

    static Future<void> changePassword(BuildContext context,String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cred = EmailAuthProvider.credential(
          email: user.email!, password: currentPassword);

      try {
        await user.reauthenticateWithCredential(cred);
        try {
          await user.updatePassword(newPassword).then((value) =>
              Utils.scaffoldMessengerSnackBar(context, 'Password Updated'));
          Navigator.pop(context);
        } on FirebaseAuthException catch (e) {
          Utils.scaffoldMessengerSnackBar(context, e.code);
        }
      } on FirebaseAuthException catch (e) {
        Utils.scaffoldMessengerSnackBar(context, e.code);
      }
    }
  }
}
