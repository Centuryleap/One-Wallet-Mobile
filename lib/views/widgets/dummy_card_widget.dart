import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_wallet/app/database/database.dart';
import 'package:google_fonts/google_fonts.dart';

class DummyCardWidget extends StatefulWidget {
  final CardData cardModel;

  const DummyCardWidget({
    required this.cardModel,
    Key? key,
  }) : super(key: key);

  @override
  State<DummyCardWidget> createState() => _DummyCardWidgetState();
}

class _DummyCardWidgetState extends State<DummyCardWidget> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //this is the card background
        SvgPicture.asset(
          'assets/card-template.svg',
          width: MediaQuery.of(context).size.width,
        ),

        //this contains all card details like card number, card name, cvv etc
        Positioned(
            top: 32.h,
            left: 24.w,
            child: SizedBox(
              width: 296.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.cardModel.bankName,
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        }),
                        child: CircleAvatar(
                            radius: 20.r,
                            backgroundColor: const Color(0xffC4C4D2),
                            child: Image.asset(
                              isObscured
                                  ? 'assets/reveal.png'
                                  : 'assets/obscure.png',
                              width: 20.w,
                              height: 20.w,
                            )),
                      )
                    ],
                  ),
                  SizedBox(height: 40.h),
                  //create text widget with cardModel.cardNumber and seperate it by 4 digits with space in between
                  Text(
                    widget.cardModel.cardNumber.isEmpty
                        ? 'XXXX   XXXX   XXXX   XXXX'
                        : isObscured
                            ? widget.cardModel.cardNumber
                                .replaceAll(RegExp(r'(?<=.{4})\d(?=.{4})'), '*')
                            : widget.cardModel.cardNumber.replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{4})+(?!\d))'),
                                (Match m) => '${m[1]}   '),
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: 216.w,
                    child: Row(
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
                              widget.cardModel.cardHolderName,
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
                              widget.cardModel.expiryDate,
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
                              widget.cardModel.cvvCode,
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }
}
