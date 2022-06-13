import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_wallet/core/Firebase/firebase_api.dart';
import 'package:one_wallet/core/csv_logic.dart';
import 'package:one_wallet/app/database/database.dart';
import 'package:provider/provider.dart';
import 'change_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    getRealPreferences();
    super.initState();
  }

  getRealPreferences() async {
    SharedPreferences prefs = await _prefs;

    setState(() {
      _toggled = prefs.getBool('fingerprintAllowed') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return ValueListenableBuilder(
      valueListenable: Hive.box('savedDarkTheme').listenable(),
      builder: ((context, Box box, child) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return Scaffold(
          backgroundColor:
              darkMode ? const Color(0xff0B0B0B) : const Color(0xffFAFAFA),
          body: SafeArea(
            child: SingleChildScrollView(
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
                          color: darkMode
                              ? const Color(0xffFFFFFF)
                              : const Color(0xff02003D)),
                    ),
                    SizedBox(height: 54.h),
                    Text(
                      'Account',
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 20.sp,
                        color: darkMode
                            ? const Color(0xffB5B3C5)
                            : const Color(0xff505780),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: darkMode
                              ? const Color(0xff24017D)
                              : const Color(0xff02003D),
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 32.r,
                            child: Image.asset('assets/profile_picture.png'),
                          ),
                          title: Text(
                            currentUser != null &&
                                    currentUser!.displayName != null
                                ? currentUser!.displayName!
                                : 'Jenny wilson',
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: darkMode
                                  ? const Color(0xffDDDDDD)
                                  : Colors.white,
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
                                color: darkMode
                                    ? const Color(0xffB5B3C5)
                                    : const Color(0xffAAA8BD),
                              )),
                        )),
                    SizedBox(height: 30.h),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 20.sp,
                        color: darkMode
                            ? const Color(0xffB5B3C5)
                            : const Color(0xff505780),
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
                          backgroundColor:
                              darkMode ? const Color(0xff111111) : Colors.white,
                          child: Icon(
                            Iconsax.key,
                            size: 16.sp,
                            color: darkMode
                                ? const Color(0xffB5B3C5)
                                : const Color(0xffAAA8BD),
                          ),
                        ),
                        title: Text(
                          'Change password',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: darkMode
                                ? Colors.white
                                : const Color(0xff0B0B0B),
                          ),
                        ),
                        trailing: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: darkMode
                                ? const Color(0xff0B0B0B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(CupertinoIcons.right_chevron,
                              color: darkMode
                                  ? const Color(0xffB5B3C5)
                                  : const Color(0xffAAA8BD)),
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
                        backgroundColor:
                            darkMode ? const Color(0xff111111) : Colors.white,
                        child: SvgPicture.asset(
                          'assets/fingerprint_tiny_svg.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                      ),
                      title: Text(
                        'Enable finger print/Face ID',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color:
                              darkMode ? Colors.white : const Color(0xff0B0B0B),
                        ),
                      ),
                      activeColor: darkMode
                          ? const Color(0xff4E09FF)
                          : const Color(0xff02003D),
                    ),
                    SizedBox(height: 15.h),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: darkMode,
                      onChanged: (value) {
                        box.put('darkMode', value);
                      },
                      secondary: CircleAvatar(
                        radius: 24.r,
                        backgroundColor:
                            darkMode ? const Color(0xff111111) : Colors.white,
                        child: SvgPicture.asset(
                          'assets/dark-mode.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                      ),
                      title: Text(
                        'Enable dark mode',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color:
                              darkMode ? Colors.white : const Color(0xff0B0B0B),
                        ),
                      ),
                      activeColor: darkMode
                          ? const Color(0xff4E09FF)
                          : const Color(0xff02003D),
                    ),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () => CsvLogic.loadCSV(context),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                            radius: 24.r,
                            backgroundColor: darkMode
                                ? const Color(0xff111111)
                                : Colors.white,
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
                            color: darkMode
                                ? Colors.white
                                : const Color(0xff0B0B0B),
                          ),
                        ),
                        trailing: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: darkMode
                                ? const Color(0xff0B0B0B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: const Icon(CupertinoIcons.right_chevron,
                              color: Color(0xffAAA8BD)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () => CsvLogic.generateCSV(context),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                            radius: 24.r,
                            backgroundColor: darkMode
                                ? const Color(0xff111111)
                                : Colors.white,
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
                            color: darkMode
                                ? Colors.white
                                : const Color(0xff0B0B0B),
                          ),
                        ),
                        trailing: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: darkMode
                                ? const Color(0xff0B0B0B)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: const Icon(CupertinoIcons.right_chevron,
                              color: Color(0xffAAA8BD)),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    GestureDetector(
                      onTap: () => FirebaseApi.signOut(context),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                            radius: 24.r,
                            backgroundColor: darkMode ? const Color(0xff111111) : Colors.white,
                            child: Icon(
                              Iconsax.logout,
                              size: 16.sp,
                              color: darkMode ? const Color(0xffB5B3C5) : const Color(0xffFF0000),
                            )),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: darkMode ? Colors.white : const Color(0xff0B0B0B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
