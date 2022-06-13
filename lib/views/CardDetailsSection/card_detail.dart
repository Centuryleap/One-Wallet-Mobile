// ignore_for_file: prefer_const_literals_to_create_immutables,

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_wallet/app/utils/utils.dart';
import 'package:one_wallet/views/CardDetailsSection/edit_card_screen.dart';
import 'package:one_wallet/app/database/database.dart';
import 'package:one_wallet/views/widgets/dummy_card_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CardDetails extends StatefulWidget {
  final CardData cardModel;
  const CardDetails({required this.cardModel, Key? key}) : super(key: key);

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

late AppDatabase database;
bool _isDeleted = false;

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return ValueListenableBuilder(
      valueListenable: Hive.box('savedDarkTheme').listenable(),
      builder: ((context, Box box, child) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return Scaffold(
          backgroundColor: darkMode ? const Color(0xff0B0B0B) : Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: darkMode ? Colors.white : const Color(0xff292D32),
                      
                    ),
                  ),
                  SizedBox(height: 32.h),
                  DummyCardWidget(cardModel: widget.cardModel),
                  SizedBox(height: 50.h),
                  Text(
                    'Manage card',
                    style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: darkMode ? Colors.white : const Color(0xff0B0B0B)),
                  ),
                  SizedBox(height: 24.h),
                  GestureDetector(
                    //this function copies only the card number
                    onTap: () {
                      Clipboard.setData(
                              ClipboardData(text: widget.cardModel.cardNumber))
                          .then((value) => Utils.scaffoldMessengerSnackBar(
                              context, 'Card number copied to clipboard'));
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 20),
                      leading: SvgPicture.asset('assets/copy_tiny_svg.svg',
                      color: darkMode ? Colors.white : Colors.black,),
                      title: Text(
                        'Copy card details',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          fontFamily: 'SF-Pro',
                          color: darkMode ? Colors.white  :  const Color(0xff505780),
                        ),
                      ),
                      subtitle: Text(
                        'Copy card number, name and expiry date',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: darkMode ? const  Color(0xffB5B3C5) : const Color(0xffAAA8BD),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  GestureDetector(
                    onTap: () async {
                      var res = await Navigator.of(context).push(PageTransition(
                          child: EditCardScreen(cardModel: widget.cardModel),
                          type: PageTransitionType.rightToLeft));
                      if (res != null && res == true) {
                        Navigator.pop(context);
                      }
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 20),
                      leading:  Icon(Iconsax.setting_4,
                          color: darkMode ? Colors.white : const Color(0xff02003D)),
                      title: Text(
                        'Edit card',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: darkMode ? Colors.white : const Color(0xff505780),
                        ),
                      ),
                      subtitle: Text(
                        'Change your card details',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: darkMode ? const Color(0xffB5B3C5) : const Color(0xffAAA8BD),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: const Text('Delete card'),
                                  content: const Text(
                                      'Are you sure you want to delete this card?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _isDeleted = true;
                                        },
                                        child:  Text(
                                          'Yes',
                                          textAlign: TextAlign.end,
                                           style: TextStyle(
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child:  Text(
                                          'No',
                                          textAlign: TextAlign.end,
                                           style: TextStyle(
                                            color: darkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),)
                                  ]));
                      _isDeleted ? database.deleteCard(widget.cardModel) : null;

                      _isDeleted ? Navigator.pop(context) : null;
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 20),
                      leading:
                           Icon(Iconsax.trash, color: darkMode ? Colors.white : const Color(0xff02003D)),
                      title: Text(
                        'Delete card',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: darkMode ? Colors.white :  const Color(0xff505780),
                        ),
                      ),
                      subtitle: Text(
                        'Delete this card',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: darkMode ? const Color(0xffB5B3C5) : const Color(0xffAAA8BD),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
