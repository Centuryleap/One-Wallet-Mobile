import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:one_wallet/OnboardingProcess/splash_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_wallet/database/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/constants/theme_provider/app_theme.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('savedDarkTheme');
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent, // transparent status bar
    ),
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //this loads the onboarding image before app loads to reduce lag effect
    precacheImage(const AssetImage('assets/onboarding_card.png'), context);
    //this loads the no card illustration before app loads to reduce lag effect
    precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoderBuilder,
            'assets/no_card_available_illustration.svg'),
        context);
    return Provider(
      //provider here is connected to the appdatabase created using drift a.k.a moor
      create: (_) => AppDatabase(),
      //this widget was created to be able to click anywhere on the screen of the app to remove keyboard
      child: DismissKeyboard(
        child: ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (child) {
              return ValueListenableBuilder(
                valueListenable: Hive.box('savedDarkTheme').listenable(),
                builder: (context, Box box, widget) {
                  var darkMode = box.get('darkMode', defaultValue: false);
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Flutter Demo',
                      themeMode: darkMode ? ThemeMode.light : ThemeMode.light,
                      theme: AppTheme.lightTheme(),
                      darkTheme: AppTheme.darkTheme(),
                      home: const SplashScreen());
                },
              );
            }),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
