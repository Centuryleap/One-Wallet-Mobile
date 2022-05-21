//  prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_wallet/AddCardSection/add_card_screen.dart';
import 'package:one_wallet/database/database.dart';
import 'package:one_wallet/widgets/bank_list_widget.dart';
import 'package:one_wallet/widgets/no_card_available_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCards extends StatefulWidget {
  const MyCards({Key? key}) : super(key: key);

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  //this is just used to get firebaseuser, it can return a value or null
  final currentUser = FirebaseAuth.instance.currentUser;

//i created this string so i dont have to be typing it everytime i want to style a text
  String sfpro = 'SF-Pro';

  // this is used to get database from drift a.k.a moor
  late AppDatabase database;
  @override
  Widget build(BuildContext context) {
    //gets the database from the provider
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 76.h),
              SvgPicture.asset(
                'assets/onboarding_screen_svg_black.svg',
                width: 154.w,
                height: 34.h,
              ),
              SizedBox(height: 40.h),
              //this is the widget that shows the man holding the cofee and name of the user
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 24.w,
                      top: 36.h,
                    ),
                    width: double.infinity,
                    height: 148.h,
                    decoration: BoxDecoration(
                      color: const Color(0xff02003D),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedTextKit(
                                totalRepeatCount: 2,
                                animatedTexts: [
                                  WavyAnimatedText('Hi ',
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: sfpro,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ]),
                            AnimatedTextKit(
                                totalRepeatCount: 2,
                                animatedTexts: [
                                  WavyAnimatedText(
                                    currentUser != null
                                        ? currentUser!.displayName!
                                        : 'User',
                                    textStyle: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ])
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Welcome back',
                          style: TextStyle(
                            color: const Color(0xffAAA8BD),
                            fontFamily: sfpro,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: const AddCardScreen(),
                                    type: PageTransitionType.bottomToTop,
                                    duration:
                                        const Duration(milliseconds: 500)));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 28.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: const Color(0xffFFFFFF).withOpacity(.24),
                            ),
                            child: Text('Add Card',
                                style: TextStyle(
                                  color: const Color(0xffFFFFFF),
                                  fontFamily: sfpro,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0.h,
                      right: -40.w,
                      child: Image.asset(
                        'assets/man_holding_cup.png',
                        width: 264.w,
                        height: 211.h,
                      ))
                ],
              ),
              SizedBox(height: 48.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My cards',
                    style: TextStyle(
                        fontFamily: sfpro,
                        fontSize: 16.sp,
                        color: const Color(0xff505780),
                        fontWeight: FontWeight.w400),
                  ),
                  Text('',
                      style: TextStyle(
                          fontFamily: sfpro,
                          fontSize: 14,
                          color: const Color(0xff5F00F8),
                          fontWeight: FontWeight.w400))
                ],
              ),

              //this streambuilder is used to check the list of card data in the database and update the widgets in real time
              StreamBuilder<List<CardData>>(
                stream: _watchCards(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('There was an error'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return BankListWidget(cardList: snapshot.data!);
                    } else {
                      return const NoCardWidget();
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<CardData>> _watchCards() {
    return database.watchEntriesInCard();
  }
}
