
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_wallet/views/OnboardingProcess/sign_up_screen.dart';

import 'log_in_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xff0B0B0B,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 24.w, top: 76.h),
              child: SvgPicture.asset(
                'assets/onboarding_screen_svg_white.svg',
                height: 34.h,
                width: 154.w,
              ),
            ),
             SizedBox(
              height: 11.h,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Image.asset('assets/onboarding_card.png', width:337.w, height:372.h),
            ),
           SizedBox(
              height: 66.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Manage all your cards ',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SF-Pro',
                    fontSize: 28.sp, 
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24.w),
              //this text was wrapped by container for automatic allignment
              child: SizedBox(
                child:  Text(                                                                                                                                                                                              
                  'Hold and manage all your card information safely, on one platform.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      height: 1.5,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SF-Pro',
                      color:const Color(0xffAAA8BD)),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                          (route) => false);
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 52.w, vertical: 21.h),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (builder) => const LoginScreen()),
                            );
                    },
                    color: const Color(0xff32363C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding:  EdgeInsets.symmetric(horizontal: 52.w, vertical: 21.h),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
