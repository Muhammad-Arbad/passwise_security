import 'package:flutter/material.dart';
import 'package:passwise_security/constants/custom_colors.dart';
import 'package:passwise_security/views/splash.dart';
import 'package:passwise_security/widgets/custom_button.dart';
import 'package:passwise_security/widgets/our_scaffold.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: OurScaffoldTemplate(
        showFAB: false,
        bodyWidget: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "No internet",
                style: TextStyle(fontSize: 40),
              ),
              Icon(
                Icons.wifi_off_outlined,
                size: 80,
                color: CustomColors().customBlueColor,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButtonWidget(
                      btntext: 'Relod',
                      btnonPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplashScreen(),
                          ),
                        );
                      }),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
