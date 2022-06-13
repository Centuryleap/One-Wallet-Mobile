import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:one_wallet/app/utils/utils.dart';
import 'package:one_wallet/views/HomeSection/bottom_navigation.dart';
import 'package:one_wallet/views/OnboardingProcess/sign_up_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:one_wallet/views/ProfileSection/update_username.dart';

import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ignore: close_sinks

  //this key is used to validate the forms
  final formKey = GlobalKey<FormState>();

//this controllers are used to get the values from the appropriate text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotPasswordEmailController =
      TextEditingController();

  //this boolean is used to check if the user has clicked on the sign up button and know wether to show CircularProgressIndicator or not
  bool loading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('savedDarkTheme').listenable(),
      builder: ((context, Box box, child) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return Scaffold(
          backgroundColor: darkMode ? const Color(0xff0B0B0B) : Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 86.h, left: 24.w, right: 24.w),
              child: Form(
                key: formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/one_wallet_logo.svg',
                        width: 56.w,
                        height: 56.h,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        'Welcome!',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SF-Pro',
                            fontSize: 24.sp,
                            color: darkMode ? Colors.white : Colors.black),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        'Hey there, enter your\ndetails to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.6,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF-Pro',
                          color: darkMode
                              ? const Color(0xffDDDDDD)
                              : const Color(0xff505780),
                        ),
                      ),
                      SizedBox(
                        height: 56.h,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                                color: darkMode
                                    ? const Color(0xffDDDDDD)
                                    : const Color(0xffAAA8BD),
                                fontSize: 14.sp,
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.w400),
                            floatingLabelStyle:
                                const TextStyle(color: Color(0xff02003D)),
                            fillColor: darkMode
                                ? const Color(0xff111111)
                                : const Color(0xffFAFBFF),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(16.r))),
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText ? Iconsax.eye_slash : Iconsax.eye,
                                size: 16.sp,
                                color: darkMode
                                    ? const Color(0xffDDDDDD)
                                    : const Color(0xff292D32),
                              ),
                            ),
                            filled: true,
                            hintText: 'Enter password',
                            hintStyle: TextStyle(
                                color: darkMode ? const Color(0xffDDDDDD) :  const Color(0xffAAA8BD),
                                fontSize: 14.sp,
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.w400),
                            floatingLabelStyle:
                                const TextStyle(color: Color(0xff02003D)),
                            fillColor: darkMode ? const Color(0xff111111) : const Color(0xffFAFBFF),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(16.r))),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => _showSheet(context),
                            child: Text(
                              'Forgot password',
                              style: TextStyle(
                                color: darkMode ? const Color(0xff6D13FF) : const Color(0xff5F00F8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.sp,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          //this conditonal checks if the form is valid for submission or not and only then does it try to login the user
                          if (formKey.currentState!.validate()) {
                            try {
                              //when this button is pressed the loading variable is set to true and the CircularProgressIndicator is shown
                              setState(() {
                                loading = true;
                              });
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                if (user.displayName != null) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomNavigationScreen(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UpdateUsernameScreen(),
                                    ),
                                  );
                                }
                              }
                            } on FirebaseAuthException catch (e) {
                              //when the exception is caught the loading variable is set to false and the CircularProgressIndicator is hidden
                              setState(() {
                                loading = false;
                              });
                              if (e.code == 'invalid-email') {
                                Utils.scaffoldMessengerSnackBar(
                                    formKey.currentState!.context,
                                    'Invalid Email');
                              } else if (e.code == 'user-disabled') {
                                Utils.scaffoldMessengerSnackBar(
                                    formKey.currentState!.context,
                                    'User Disabled');
                              } else if (e.code == 'wrong-password') {
                                Utils.scaffoldMessengerSnackBar(
                                    formKey.currentState!.context,
                                    'Wrong Password Entered');
                              } else if (e.code == 'user-not-found') {
                                Utils.scaffoldMessengerSnackBar(
                                    formKey.currentState!.context,
                                    'User not found');
                              } else {
                                Utils.scaffoldMessengerSnackBar(
                                    formKey.currentState!.context,
                                    'User Disabled');
                              }
                            }
                          }
                        },
                        color: darkMode ? const Color(0xff4E09FF) : const Color(0xff02003D),
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 18.h),
                        child: loading
                            ? SizedBox(
                                height: 11.h,
                                width: 11.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ))
                            : Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                      ),
                      SizedBox(
                        height: 38.h,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'New to Onewallet? ',
                          style: TextStyle(
                            color: darkMode ? const Color(0xffDDDDDD) : const Color(0xffAAA8BD),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                                text: 'Create account',
                                style: TextStyle(
                                  color: darkMode ? const Color(0xff6D13FF) : const Color(0xff5F00F8),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const SignUpScreen()),
                                    );
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showSheet(BuildContext context) {
    showFlexibleBottomSheet(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 0.5,
      context: context,
      builder: (context, controller, offset) {
        return ValueListenableBuilder(
            valueListenable: Hive.box('savedDarkTheme').listenable(),
      builder: ((context, Box box, child) {
        var darkMode = box.get('darkMode', defaultValue: false);
          return Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r),
              topRight: Radius.circular(32.r),
            ),
            child: Container(
              decoration: BoxDecoration(
                color:  darkMode ? const Color(0xff111111) : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
              ),
              child: ListView(
                controller: controller,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 32.h,
                        ),
                        SvgPicture.asset('assets/Rectangle.svg'),
                        SizedBox(
                          height: 32.h,
                        ),
                        Text(
                          'Forgot password',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: darkMode ? Colors.white : const Color(0xff0B0B0B),
                            fontSize: 24.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Enter email attached to your account',
                          style: TextStyle(
                              color: darkMode ? const Color(0xffDDDDDD) :  const Color(0xff505780),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Gotham',
                              fontSize: 14.sp),
                        ),
                        SizedBox( 
                          height: 40.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: TextField(
                            controller: _forgotPasswordEmailController,
                            autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                filled: true,
                                labelText: 'Email Address',
                                labelStyle: TextStyle(
                                  color:darkMode ? const Color(0xffDDDDDD) : const Color(0xffAAA8BD),
                                  fontSize: 14.sp,
                                ),
                                floatingLabelStyle:
                                    const TextStyle(color: Color(0xff02003D)),
                                fillColor: darkMode ? const Color(0xff111111) : const Color(0xffFAFBFF),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16.r))),
                          ),
                        ),
                        SizedBox(
                          height: 48.h,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            if (_forgotPasswordEmailController.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: 'There is no email entered',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            } else {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email:
                                            _forgotPasswordEmailController.text);
                                Navigator.of(context).pop();
                                Utils.scaffoldMessengerSnackBar(
                                    formKey.currentState!.context, 'Email Sent');
                              } on FirebaseAuthException catch (e) {
                                Utils.scaffoldMessengerSnackBar(
                                    formKey.currentState!.context, e.code);
                              }
                            }
                          },
                          color: darkMode ? const Color(0xff4E09FF) :const Color(0xff02003D),
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
      }),
        );
      },
    );
  }

  // void _showSecondSheet(BuildContext context) {
  //   TextEditingController textEditingController = TextEditingController();
  //   showFlexibleBottomSheet(
  //     minHeight: 0,
  //     initHeight: 0.5,
  //     maxHeight: 0.5,
  //     context: context,
  //     builder: (context, controller, offset) {
  //       return Material(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(32),
  //           topRight: Radius.circular(32),
  //         ),
  //         child: Container(
  //           decoration: const BoxDecoration(
  //             color: Color(0xFFFFFFFF),
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(32),
  //               topRight: Radius.circular(32),
  //             ),
  //           ),
  //           child: ListView(
  //             controller: controller,
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 24),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     SizedBox(
  //                       height: 32.h,
  //                     ),
  //                     SvgPicture.asset('assets/Rectangle.svg'),
  //                     SizedBox(
  //                       height: 32.h,
  //                     ),
  //                     Text(
  //                       'Enter OTP',
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w700,
  //                         color: Color(0xff0B0B0B),
  //                         fontSize: 24,
  //                       ),
  //                     ),
  //                     SizedBox(height: 6),
  //                     Text(
  //                       'Enter the 6-digit code sent to your email',
  //                       style: TextStyle(
  //                           color: Color(0xff505780),
  //                           fontWeight: FontWeight.w400,
  //                           fontFamily: 'Gotham',
  //                           fontSize: 14),
  //                     ),
  //                     SizedBox(
  //                       height: 40,
  //                     ),
  //                     Form(
  //                       key: formKey,
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                             border: Border.all(
  //                               width: 1,
  //                               color: Color(0xffFFFFFF),
  //                             ),
  //                             borderRadius: BorderRadius.circular(12)),
  //                         padding: EdgeInsets.only(
  //                             left: 60, right: 60, top: 15, bottom: 5),
  //                         child: PinCodeTextField(
  //                           appContext: context,
  //                           pastedTextStyle: TextStyle(
  //                             color: Colors.green.shade600,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                           length: 6,
  //                           obscureText: true,

  //                           blinkWhenObscuring: true,
  //                           animationType: AnimationType.fade,

  //                           pinTheme: PinTheme(
  //                             fieldWidth: 18,
  //                             fieldHeight: 28,
  //                             activeColor: Color(0xffd2d2d2),
  //                             inactiveColor: Color(0xffd2d2d2),
  //                             activeFillColor: Colors.white,
  //                           ),
  //                           cursorColor: Colors.transparent,
  //                           animationDuration: Duration(milliseconds: 100),
  //                           // enableActiveFill: true,

  //                           //I  removed error controller here because it was giving me issues , to put back later

  //                           controller: textEditingController,
  //                           keyboardType: TextInputType.number,

  //                           onCompleted: (v) {
  //                             print("Completed");
  //                           },

  //                           onChanged: (value) {
  //                             print(value);
  //                             setState(() {
  //                               currentText = value;
  //                             });
  //                           },
  //                           beforeTextPaste: (text) {
  //                             print("Allowing to paste $text");
  //                             //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
  //                             //but you can show anything you want here, like your pop up saying wrong paste format or etc
  //                             return true;
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 48,
  //                     ),
  //                     MaterialButton(
  //                       onPressed: () {},
  //                       color: Color(0xff02003D),
  //                       minWidth: double.infinity,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(24),
  //                       ),
  //                       padding: EdgeInsets.symmetric(vertical: 20),
  //                       child: Text(
  //                         'Verify',
  //                         style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w500),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
