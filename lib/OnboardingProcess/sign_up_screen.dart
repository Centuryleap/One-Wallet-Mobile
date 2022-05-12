import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_wallet/OnboardingProcess/log_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //this key is used for form validation
  final _formKey = GlobalKey<FormState>();

//this controllers are used to get the values from the appropriate text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //this boolean is used to check if the user has clicked on the sign up button and know wether to show CircularProgressIndicator or not
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 86.h, left: 24.w, right: 24.w),
          child: Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.center,
              child: Column(
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
                    'Create account',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SF-Pro',
                        fontSize: 24.sp,
                        color: Colors.black),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Sign up with the provided \nmeans to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.6,
                      fontFamily: 'SF-Pro',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff505780),
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
                        labelText: 'Email Address',
                        labelStyle: TextStyle(
                            color: const Color(0xffAAA8BD),
                            fontSize: 14.sp,
                            fontFamily: 'SF-Pro',
                            fontWeight: FontWeight.w400),
                        floatingLabelStyle:
                            const TextStyle(color: Color(0xff02003D)),
                        fillColor: const Color(0xffFAFBFF),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16.r))),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Enter Password',
                        labelStyle: TextStyle(
                            color: const Color(0xffAAA8BD),
                            fontSize: 14.sp,
                            fontFamily: 'SF-Pro',
                            fontWeight: FontWeight.w400),
                        floatingLabelStyle:
                            const TextStyle(color: Color(0xff02003D)),
                        fillColor: const Color(0xffFAFBFF),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                            color: const Color(0xffAAA8BD),
                            fontSize: 14.sp,
                            fontFamily: 'SF-Pro',
                            fontWeight: FontWeight.w400),
                        floatingLabelStyle:
                            const TextStyle(color: Color(0xff02003D)),
                        fillColor: const Color(0xffFAFBFF),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          //when this button is pressed the loading variable is set to true and the CircularProgressIndicator is shown
                          setState(() {
                            loading = true;
                          });
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        } on FirebaseAuthException catch (e) {
                          //when the exception is caught the loading variable is set to false and the CircularProgressIndicator is hidden
                          setState(() {
                            loading = false;
                          });
                          if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(_formKey.currentState!.context)
                                .showSnackBar(const SnackBar(
                              content: Text('Password is too weak'),
                            ));
                          } else if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(_formKey.currentState!.context)
                                .showSnackBar(const SnackBar(
                              content: Text('Email already in use'),
                            ));
                          } else if (e.code == 'network-request-failed') {
                            ScaffoldMessenger.of(_formKey.currentState!.context)
                                .showSnackBar(const SnackBar(
                              content: Text('There was a network error'),
                            ));
                          } else {
                            ScaffoldMessenger.of(_formKey.currentState!.context)
                                .showSnackBar(const SnackBar(
                              content: Text('Something went wrong'),
                            ));
                          }
                        }
                      }
                    },
                    color: const Color(0xff02003D),
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding:  EdgeInsets.symmetric(vertical: 18.h),
                    child: loading
                        ? SizedBox(
                            height: 11.h,
                            width: 11.h,
                            child:const  CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ))
                        : Text(
                            'Create account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'SF-Pro',
                            ),
                          ),
                  ),
                 SizedBox(
                    height: 32.h,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'Already a User? ',
                          style:  TextStyle(
                            color:const Color(0xffAAA8BD),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                        TextSpan(
                            text: 'Log in to your account',
                            style:  TextStyle(
                              color:const Color(0xff5F00F8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            //this takes the user to the login screen when the text is clicked
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const LoginScreen()),
                                );
                              })
                      ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
