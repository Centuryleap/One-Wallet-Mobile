//  prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_wallet/app/database/database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class BankTile extends StatefulWidget {
  const BankTile({required this.cardModel, Key? key}) : super(key: key);

  final CardData cardModel;

  @override
  State<BankTile> createState() => _BankTileState();
}

class _BankTileState extends State<BankTile> {
  //this variable is used to control the delete dialog that pops up
  bool _isDeleted = false;

//this is the datbase from drift also called moor
  late AppDatabase database;

  @override
  Widget build(BuildContext context) {
    //this initializes thet database using provider
    database = Provider.of<AppDatabase>(context);
    return ValueListenableBuilder(
      valueListenable: Hive.box('savedDarkTheme').listenable(),
      builder: ((context, Box box, child) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Slidable(
            endActionPane: ActionPane(
              extentRatio: 0.25,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
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
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          color: darkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          color: darkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      ))
                                ]));

                    //if the user clicks yes on the dialog the card will delete if not, it wont delete
                    _isDeleted ? database.deleteCard(widget.cardModel) : null;
                  },
                  backgroundColor: Colors.red,
                  icon: Iconsax.trash,
                )
              ],
            ),
            child: buildBankTile(),
          ),
        );
      }),
    );
  }

  Widget buildBankTile() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('savedDarkTheme').listenable(),
      builder: ((context, Box box, child) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: darkMode ? const Color(0xff111111) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          //create list tile with title = cardModel.bankName, subtitle = cardModel.cardNumber and trailing = SvgPicture.asset('assets/mastercard.svg')
          child: ListTile(
            //reduce inner padding of listtile to 0
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget.cardModel.bankName,
              style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: darkMode ? Colors.white  : const Color(0xff0B0B0B)),
            ),
            //create subtitle with cardModel.cardNumber that hides the first 4 digits of the number
            subtitle: Text(
              widget.cardModel.cardNumber.replaceRange(0, 4, '****'),
              style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffB5B3C5)),
            ),

            trailing: SvgPicture.asset(
              'assets/${widget.cardModel.cardType}card.svg',
            ),
          ),
        );
      }),
    );
  }
}
