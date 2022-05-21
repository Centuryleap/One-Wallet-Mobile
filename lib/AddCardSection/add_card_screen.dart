import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_wallet/helpers/card_expiration_formatter.dart';
import 'package:one_wallet/widgets/dummy_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as dr;

import '../database/database.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  //this valriable is used to validate the forms in the screen
  final _formKey = GlobalKey<FormState>();

  //this variables are controllers attached to Form Fields to monitor them
  final bankNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cvvController = TextEditingController();

  //this variables are used to store the values of the form fields
  String bankName = '';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  String cardType = 'master';

  //use this to keep track of when the form is submitted for autovalidate for the individual forms
  bool _submitted = false;

  late AppDatabase database;

  static const menuItems = <String>['master', 'verve', 'visa'];

  final List<DropdownMenuItem<String>> _dropdownMenuItems = menuItems
      .map((value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value + 'card'),
          ))
      .toList();

  @override
  void dispose() {
    //dispose all controllers
    bankNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cardHolderNameController.dispose();
    cvvController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
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
                        width: (MediaQuery.of(context).size.width * 0.2).w),
                    Text(
                      'Add Card',
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff0B0B0B),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28.h),
                //fed the dummy card dummy values here
                DummyCardWidget(
                  cardModel: CardData(
                      id: 1,
                      cardNumber: 'XXXXXXXXXXXXXXXX',
                      bankName: '----',
                      cardHolderName: '----',
                      expiryDate: '----',
                      cvvCode: '---',
                      cardType: 'master'),
                ),
                SizedBox(height: 36.h),
                TextFormField(
                  controller: bankNameController,
                  keyboardType: TextInputType.text,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  inputFormatters: [LengthLimitingTextInputFormatter(40)],
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'Bank name',
                      hintStyle: TextStyle(
                          color: const Color(0xffAAA8BD),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400),
                      fillColor: const Color(0xffFAFBFF),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16.r))),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextFormField(
                  controller: cardHolderNameController,
                  keyboardType: TextInputType.text,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  inputFormatters: [LengthLimitingTextInputFormatter(15)],
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'Card Holder name',
                      hintStyle: TextStyle(
                          color:    const Color(0xffAAA8BD),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400),
                      fillColor: const Color(0xffFAFBFF),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16.r))),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: cardNumberController,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Please enter card number';
                    }
                    if (text.length != 16) {
                      return 'Please enter valid card number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'Card Number',
                      hintStyle: TextStyle(
                          color: const Color(0xffAAA8BD),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400),
                      fillColor: const Color(0xffFAFBFF),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16.r))),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: cvvController,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Please enter cvv code';
                    }
                    if (text.length != 3) {
                      return 'Please enter valid cvv code';
                    }
                    return null;
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(3)],
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'CVV',
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
                  keyboardType: TextInputType.number,
                  controller: expiryDateController,
                  autovalidateMode: _submitted
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  inputFormatters: [LengthLimitingTextInputFormatter(5), CardExpirationFormatter()],
                  validator: (text) {
                    if (text!.isEmpty) {
                      return 'Please enter expiry date';
                    }
                    if (text.length != 5) {
                      return 'Please enter valid expiry date';
                    }
                    if (!text.contains('/')) {
                      return 'Please input expiry date in format MM/YY';
                    }
                    if (!text.startsWith('01') ||
                        !text.startsWith('02') ||
                        !text.startsWith('03') ||
                        !text.startsWith('04') ||
                        !text.startsWith('05') ||
                        !text.startsWith('06') ||
                        !text.startsWith('07') ||
                        !text.startsWith('08') ||
                        !text.startsWith('09') ||
                        !text.startsWith('10') ||
                        !text.startsWith('11') ||
                        !text.startsWith('12')) {
                      return 'Please enter valid month';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      helperText: 'MM/YY',
                      filled: true,
                      hintText: 'Expiry Date',
                      hintStyle: TextStyle(
                          color: const Color(0xffAAA8BD),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400),
                      fillColor: const Color(0xffFAFBFF),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(16))),
                ),
                SizedBox(height: 16.h),
               
                SizedBox(
                  height: 36.h,
                ),
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      _submitted = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      bankName = bankNameController.text;
                      cardHolderName = cardHolderNameController.text;
                      cardNumber = cardNumberController.text;
                      cvvCode = cvvController.text;
                      expiryDate = expiryDateController.text;

                      if (cardNumberController.text.startsWith('4')) {
                        cardType = 'visa';
                      } else if (cardNumberController.text.startsWith('5061')) {
                        cardType = 'verve';
                      } else if (cardNumberController.text.startsWith('5') &&
                          !cardNumberController.text.startsWith('5061')) {
                        cardType = 'master';
                      } 

                      database.insertCard(CardCompanion(
                        bankName: dr.Value(bankName),
                        cardNumber: dr.Value(cardNumber),
                        expiryDate: dr.Value(expiryDate),
                        cardHolderName: dr.Value(cardHolderName),
                        cvvCode: dr.Value(cvvCode),
                        cardType: dr.Value(cardType),
                      ));
                      await _showCompletedDialog(context);

                      Navigator.of(context).pop();
                    }
                  },
                  color: const Color(0xff02003D),
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: Text(
                    'Add Card',
                    style: TextStyle(
                        fontFamily: 'SF-Pro',
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//this is the dialog that shows after the user adds new card
  Future<dynamic> _showCompletedDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/dialog_illustration.png',
                width: 109, height: 109),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Welldone!',
              style: TextStyle(
                fontFamily: 'SF-Pro',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xff0B0B0B),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              'You have successfully added\n a card to your wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SF-Pro',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xffAAA8BD),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: const Color(0xff02003D),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 62),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text('Done',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
