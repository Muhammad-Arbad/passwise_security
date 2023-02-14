import 'package:flutter/material.dart';
import 'package:passwise_security/constants/custom_colors.dart';

class CustomButtonWidget extends StatefulWidget {
  CustomButtonWidget({required this.btntext,this.btncolor,this.btnonPressed,this.borderRadius});
  String btntext;
  Color? btncolor;
  VoidCallback? btnonPressed;
  double? borderRadius;

  @override
  State<CustomButtonWidget> createState() => _CustomButtonWidgetState();
}

class _CustomButtonWidgetState extends State<CustomButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(widget.btntext,style: TextStyle(fontWeight: FontWeight.bold),),
      style: ElevatedButton.styleFrom(
        primary: CustomColors().customBlueColor,
        padding: EdgeInsets.all(18),
        onPrimary: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: widget.borderRadius==null?BorderRadius.circular(30):BorderRadius.circular(widget.borderRadius!),
            side: BorderSide(color: CustomColors().customBlueColor)),
      ),
      onPressed: widget.btnonPressed,
    );
  }
}