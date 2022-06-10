// prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:one_wallet/core/Firebase/firebase_api.dart';

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


  bool _obscureOldPasswordText = true;
  bool _obscureNewPasswordText = true;
  bool _obscureConfirmPasswordText = true;

    bool loadingCircular = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ),
            child: Form(
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
                    obscureText: _obscureOldPasswordText,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureOldPasswordText =
                                    !_obscureOldPasswordText;
                              });
                            },
                            child: Icon(
                                _obscureOldPasswordText
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                                size: 16.sp)),
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
                    obscureText: _obscureNewPasswordText,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureNewPasswordText =
                                    !_obscureNewPasswordText;
                              });
                            },
                            child: Icon(
                                _obscureNewPasswordText
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                                size: 16.sp)),
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
                    obscureText: _obscureConfirmPasswordText,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureConfirmPasswordText =
                                    !_obscureConfirmPasswordText;
                              });
                            },
                            child: Icon(
                                _obscureConfirmPasswordText
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                                size: 16.sp)),
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
                    onPressed: () async  {
                      setState(() {
                        loadingCircular = true;
                        print('true');
                      });
                      if (formKey.currentState!.validate()) {
                        await FirebaseApi.changePassword(
                            formKey.currentState!.context,
                            oldPasswordController.text,
                            confirmPasswordController.text);
                      }
                      setState(() {
                        loadingCircular = false;
                        print('false');
                      });
                    },
                    color: const Color(0xff02003D),
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: loadingCircular
                        ? SizedBox(
                            height: 11.h,
                            width: 11.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ))
                        : Text(
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

}
