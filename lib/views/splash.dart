import 'package:flutter/material.dart';
import 'package:passwise_security/constants/custom_colors.dart';
import 'package:passwise_security/sharedPreferences/user_preferences.dart';
import 'package:passwise_security/views/sign_in.dart';
import 'package:passwise_security/views/visitor_list.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToHomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors().customBlueColor,
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(""),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("PASS ",style: TextStyle(fontSize: 20,color: Colors.white),),
                        Text(
                          "WISE",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage('assets/logo/logo.png')),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
                Text(
                  "www.passwise.app",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )),
    );
  }

  void goToHomeScreen() async {
    await Future.delayed(Duration(milliseconds: 2000));

    if (UserPreferences.getUserToken() == null ||
        UserPreferences.getUserToken() == "null" ||
        DateTime.now().isAfter(DateTime.parse(
            (UserPreferences.getExpiryTime()) ?? DateTime.now().toString()))) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => VisitorList()));
    }
  }
}
