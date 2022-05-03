//, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:one_wallet/AddCardSection/add_card_screen.dart';
import 'package:one_wallet/HomeSection/my_cards_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_wallet/ProfileSection/settings_screen.dart';
import 'package:page_transition/page_transition.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  //this stores the list of screen that can be navigated to
  final List<Widget> _screens = [const MyCards(), SettingsScreen()];

  //used to check the current screen
  int _selectedIndex = 0;

//used to set the current screen
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      //create a floating action bar with floatingActionButtonLocation center docked and icon : Icons.add
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 56,
        width: 56,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(PageTransition(
                  child: const AddCardScreen(),
                  type: PageTransitionType.bottomToTop,
                  duration: const Duration(milliseconds: 600)));
            },
            child: const Icon(
              Iconsax.add,
              color: Colors.white,
            ),     
            backgroundColor: const Color(0xff02003D),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: false,
        elevation: 0,
        backgroundColor: const Color(0xffFAFAFA),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'My cards',
            icon: _selectedIndex == 0
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(
                      Iconsax.cards5,
                      color: Color(0xff02003D),
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: const Icon(
                      Iconsax.cards,
                      color: const Color(0xffAAA8BD),
                    ),
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: _selectedIndex == 1
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    //i couldnt use the Iconsax.setting5 bold icon here because it has a padding bug and its not my problem to solve
                    child: SvgPicture.asset(
                        'assets/bottom_navbar_setting_blue.svg'),
                  )
                : const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(
                      Iconsax.setting,
                      color: const Color(0xffAAA8BD),
                    ),
                  ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff02003D),
        unselectedItemColor: const Color(0xffAAA8BD),
        onTap: _onItemTapped,
      ),
    );
  }
}
