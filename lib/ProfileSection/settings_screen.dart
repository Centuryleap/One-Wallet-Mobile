//  prefer_const_literals_to_create_immutables, use_full_hex_values_for_flutter_colors

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_wallet/ProfileSection/update_username.dart';
import 'package:one_wallet/database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'change_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart' as dr;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _prefs = SharedPreferences.getInstance();
  bool _toggled = false;

  final currentUser = FirebaseAuth.instance.currentUser;

  late AppDatabase database;

  @override
  void initState() {
    // TODO: implement initState

    getRealPreferences();
    super.initState();
  }

  getRealPreferences() async {
    SharedPreferences prefs = await _prefs;

    setState(() {
      _toggled = prefs.getBool('fingerprintAllowed') ?? false;
    });
  }

  List<List<dynamic>> loadedCsv = [];
  Future<List<List<dynamic>>> _loadCSV() async {
    String path = '/storage/emulated/0/OneWallet/cards.csv';

    final newFile = File(path);

    if (await newFile.exists()) {
      final file = newFile.openRead();

      loadedCsv = await file
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      if (loadedCsv.length > 1) {
        for (var i = 1; i < loadedCsv.length; i++) {
          database.insertCard(CardCompanion(
            bankName: dr.Value(loadedCsv[i][1].toString()),
            cardNumber: dr.Value(loadedCsv[i][2].toString()),
            expiryDate: dr.Value(loadedCsv[i][3].toString()),
            cardHolderName: dr.Value(loadedCsv[i][4].toString()),
            cvvCode: dr.Value(loadedCsv[i][5].toString()),
            cardType: dr.Value(loadedCsv[i][6].toString()),
            
          ));
        }
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data imported successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No data to import')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No data to import')));
    }

    print(loadedCsv);

    return loadedCsv;
  }

  Future<void> _generateCSV(BuildContext context) async {
    AppDatabase database = Provider.of<AppDatabase>(context, listen: false);
    List<CardData> cards = await database.allCards;
    List<List<String>> csvData = [
      [
        'id',
        'Bank Name',
        'Card Number',
        'Expiry Date',
        'Card Holder Name',
        'CVV code',
        'Card Type'
      ],
      ...cards.map((item) => [
            item.id.toString(),
            item.bankName,
            item.cardNumber,
            item.expiryDate,
            item.cardHolderName,
            item.cvvCode,
            item.cardType ?? 'Unknown'
          ]),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    await Permission.manageExternalStorage.request();

    Directory directory = (await getExternalStorageDirectory())!;
    String fileName = 'cards.csv';
    String newPath = '';
    print('directory: $directory');

    List<String> paths = directory.path.split('/');

    for (var i = 1; i < paths.length; i++) {
      String currentFolder = paths[i];
      if (currentFolder != 'Android') {
        newPath += '/' + currentFolder;
      } else {
        break;
      }
    }

    newPath = newPath + '/OneWallet';
    print('New Path : $newPath');
    directory = Directory(newPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    if (await directory.exists()) {
      final File file = File(directory.path + '/$fileName');
      await file.writeAsString(csv).then((value) =>
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Data exported successfully to storage/emulated/0/OneWallet/cards.csv'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h),
              Text(
                'Settings',
                style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff02003D)),
              ),
              SizedBox(height: 54.h),
              Text(
                'Account',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: 20.sp,
                  color: const Color(0xff505780),
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff02003D),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 32.r,
                      child: Image.asset('assets/profile_picture.png'),
                    ),
                    title: Text(
                      currentUser != null && currentUser!.displayName != null
                          ? currentUser!.displayName!
                          : 'Jenny wilson',
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                        currentUser != null
                            ? currentUser!.email!
                            : 'johndoe@gmail.com',
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffAAA8BD),
                        )),
                  )),
              SizedBox(height: 30.h),
              Text(
                'Settings',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: 20.sp,
                  color: const Color(0xff505780),
                ),
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                //use onTap to navigate to ChangePasswordScreen
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ));
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 24.r,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Iconsax.key,
                      size: 16.sp,
                      color: const Color(0xffAAA8BD),
                    ),
                  ),
                  title: Text(
                    'Change password',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: const Color(0xff0B0B0B),
                    ),
                  ),
                  trailing: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(CupertinoIcons.right_chevron,
                        color: Color(0xffAAA8BD)),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _toggled,
                onChanged: (value) async {
                  SharedPreferences prefs = await _prefs;
                  setState(() {
                    _toggled = value;

                    prefs.setBool('fingerprintAllowed', _toggled);
                  });
                },
                secondary: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    'assets/fingerprint_tiny_svg.svg',
                    width: 16.w,
                    height: 16.h,
                  ),
                ),
                title: Text(
                  'Enable finger print',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    color: const Color(0xff0B0B0B),
                  ),
                ),
                activeColor: const Color(0xff02003D),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () => _loadCSV(),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                      radius: 24.r,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Iconsax.import,
                        size: 16.sp,
                        color: const Color(0xffAAA8BD),
                      )),
                  title: Text(
                    'Import CSV',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: const Color(0xff0B0B0B),
                    ),
                  ),
                  trailing: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(CupertinoIcons.right_chevron,
                        color: Color(0xffAAA8BD)),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () => _generateCSV(context),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                      radius: 24.r,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Iconsax.export,
                        size: 16.sp,
                        color: const Color(0xffAAA8BD),
                      )),
                  title: Text(
                    'Export CSV',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: const Color(0xff0B0B0B),
                    ),
                  ),
                  trailing: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(CupertinoIcons.right_chevron,
                        color: Color(0xffAAA8BD)),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UpdateUsernameScreen(),
                )),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                      radius: 24.r,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Iconsax.info_circle,
                        size: 16.sp,
                        color: const Color(0xffAAA8BD),
                      )),
                  title: Text(
                    'Help',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: const Color(0xff0B0B0B),
                    ),
                  ),
                  trailing: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(CupertinoIcons.right_chevron,
                        color: Color(0xffAAA8BD)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
