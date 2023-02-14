import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passwise_security/sharedPreferences/user_preferences.dart';
import 'package:passwise_security/views/scan_qr.dart';
import 'package:passwise_security/views/sign_in.dart';
import 'package:passwise_security/views/splash.dart';
import 'package:passwise_security/views/visitor_allowed.dart';
import 'package:passwise_security/views/visitor_not_allowed.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ));
  await UserPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: OurScaffoldTemplate(
      //   showFAB: false,
      //   appBarWidget: Container(),
      //   bottomSheet: Container(),
      //   bodyWidget: Container(),
      // ),
      home: SplashScreen(),
      //home: SignIn(),
      //home: ScanQR(),
      //home: VisitorAllowedOrNot(),
      // home: VisitorNotAllowed(),
    );
  }
}
