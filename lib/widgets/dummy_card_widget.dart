import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_wallet/database/database.dart';
import 'package:google_fonts/google_fonts.dart';

class DummyCardWidget extends StatelessWidget {
  final CardData cardModel;
  const DummyCardWidget({required this.cardModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //this is the card background
        SvgPicture.asset(
          'assets/big_card_detail.svg',
          width: MediaQuery.of(context).size.width,
        ),

        //this contains all card details like card number, card name, cvv etc
        Positioned(
            top: 38.h,
            left: 24.w,
            child: SizedBox(
              width: 216.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardModel.bankName,
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                   SizedBox(height: 40.h),
                  //create text widget with cardModel.cardNumber and seperate it by 4 digits with space in between
                  Text(
                    cardModel.cardNumber.substring(0, 4) +
                        '   ' +
                        cardModel.cardNumber.substring(4, 8) +
                        '   ' +
                        cardModel.cardNumber.substring(8, 12) +
                        '   ' +
                        cardModel.cardNumber.substring(12, 16),
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card Holder Name',
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                         SizedBox(height: 6.h),
                          Text(
                            cardModel.cardHolderName,
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expiry date',
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cardModel.expiryDate,
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CVV',
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cardModel.cvvCode,
                            style: GoogleFonts.sourceSansPro(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ))
      ],
    );
  }
}
