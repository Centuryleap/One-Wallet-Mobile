import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_wallet/views/CardDetailsSection/card_detail.dart';
import 'package:one_wallet/app/database/database.dart';
import 'package:one_wallet/views/widgets/bank_tile_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankListWidget extends StatefulWidget {
  final List<CardData> cardList;
  const BankListWidget({Key? key, required this.cardList}) : super(key: key);

  @override
  State<BankListWidget> createState() => _BankListWidgetState();
}

class _BankListWidgetState extends State<BankListWidget> {
  final LocalAuthentication _authentication = LocalAuthentication();

  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;

  bool fingerprintActivated = false;

  @override
  void initState() {
    _checkBiometrics();
    _getAvailableBiometrics();
    getRealPreferences();
    super.initState();
  }

  getRealPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fingerprintActivated = prefs.getBool('fingerprintAllowed') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
//i surrounded this listview by flexible instead of sizedbox for some weird reason the compiler gave me, so i had to use the flexbit.loose propperty
    return Flexible(
      fit: FlexFit.loose,
      child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: ((context, index) {
            return GestureDetector(
                onTap: () => fingerprintActivated
                    ? _authenticate(context, index)
                    : Navigator.of(context).push(
                        PageTransition(
                          child: CardDetails(
                            cardModel: widget.cardList[index],
                          ),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(
                            milliseconds: 500,
                          ),
                        ),
                      ),
                child: AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 100),
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 2500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    horizontalOffset: -350,
                    verticalOffset: -10,
                    child: BankTile(
                      cardModel: widget.cardList[index],
                    ),
                  ),
                ));
          }),
          separatorBuilder: (context, _) {
            return  SizedBox(height: 8.h);
          },
          itemCount: widget.cardList.length),
    );
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _authentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = [];
    try {
      availableBiometrics = await _authentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

//this method is used to check if authenticate the user using fingerprint before showing card details
  Future<void> _authenticate(BuildContext context, int index) async {
    bool authenticated = false;
    try {
      authenticated = await _authentication.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;

    authenticated
        ? Navigator.of(context).push(
            PageTransition(
              child: CardDetails(
                cardModel: widget.cardList[index],
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(
                milliseconds: 500,
              ),
            ),
          )
        : null;

    setState(() {});
  }
}
