// prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import firebase auth package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_wallet/app/utils/utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ),
            child:

                /// A unique identifier for the form.
                Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 66.h,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.arrow_left,
                          color: const Color(0xff292D32),
                          size: 18.sp,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width * 0.192).w,
                      ),
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff0B0B0B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  TextFormField(
                    controller: oldPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your old password';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter old password',
                        hintStyle: TextStyle(
                            color: const Color(0xffAAA8BD),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: const Color(0xffFAFBFF),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextFormField(
                    controller: newPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your new password';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter new password',
                        hintStyle: TextStyle(
                            color: const Color(0xffAAA8BD),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: const Color(0xffFAFBFF),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'Confirm new password',
                        hintStyle: TextStyle(
                            color: const Color(0xffAAA8BD),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400),
                        fillColor: const Color(0xffFAFBFF),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  SizedBox(
                    height: 56.h,
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _changePassword(oldPasswordController.text,
                            confirmPasswordController.text);
                      }
                    },
                    color: const Color(0xff02003D),
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Change password',
                      style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  /// _changePassword() takes two strings, the current password and the new password, and then changes
  /// the password of the current user to the new password
  ///
  /// Args:
  ///   currentPassword (String): The user's current password.
  ///   newPassword (String): The new password.
  void _changePassword(String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cred = EmailAuthProvider.credential(
          email: user.email!, password: currentPassword);

      try {
        await user.reauthenticateWithCredential(cred);
        try {
          await user.updatePassword(newPassword).then((value) =>
              Utils.scaffoldMessengerSnackBar(formKey.currentState!.context, 'Password Updated'));
          Navigator.pop(context);
        } on FirebaseAuthException catch (e) {
          Utils.scaffoldMessengerSnackBar(formKey.currentState!.context, e.code);
        }
      } on FirebaseAuthException catch (e) {
        Utils.scaffoldMessengerSnackBar(formKey.currentState!.context, e.code);
      }
    }
  }
}
