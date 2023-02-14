import 'package:flutter/material.dart';
import 'package:passwise_security/constants/custom_colors.dart';

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({Key? key, required this.qrScan,required this.home}) : super(key: key);
  void Function()? qrScan,home;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                boxShadow: kElevationToShadow[4],
                color: CustomColors().customBlueColor,
              ),

              child: IconButton(
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed:() => home!(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                boxShadow: kElevationToShadow[4],
                color: CustomColors().customBlueColor,
              ),
              child: IconButton(
                  icon: Icon(
                    Icons.qr_code_scanner,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: ()=> qrScan!()),
            ),
          ],
        ),
      );
  }
}
