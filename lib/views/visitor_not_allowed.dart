import 'package:flutter/material.dart';
import 'package:passwise_security/constants/custom_colors.dart';
import 'package:passwise_security/models/scaned_visitor_model.dart';
import 'package:passwise_security/views/scan_qr.dart';
import 'package:passwise_security/views/visitor_list.dart';
import 'package:passwise_security/widgets/custom_bottom_sheet.dart';
import 'package:passwise_security/widgets/our_scaffold.dart';

class VisitorNotAllowed extends StatefulWidget {
  VisitorNotAllowed({Key? key}) : super(key: key);

  @override
  State<VisitorNotAllowed> createState() => _VisitorNotAllowedState();
}

class _VisitorNotAllowedState extends State<VisitorNotAllowed> {

  @override
  Widget build(BuildContext context) {
    return OurScaffoldTemplate(
      showFAB: false,
      appBarWidget: Column(
        children: [
          AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text("Not Allowed"),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("Not Allowed"),
            //     Divider(
            //       indent: 160,
            //       endIndent: 160,
            //       thickness: 2,
            //       color: Colors.white,
            //     )
            //   ],
            // ),
          ),
          Flexible(
            child: Image.asset('assets/logo/logo.png'),
          ),
        ],
      ),
      bodyWidget:
      // SingleChildScrollView(
      //   child:
      Container(
          padding: EdgeInsets.fromLTRB(
              50,
              50,
              50,
              MediaQuery.of(context).size.height*0.12+50),
          child: Center(
            //color: Colors.white,
            child: Container(

                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    boxShadow: kElevationToShadow[4],
                    color:  Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.do_not_disturb_alt_outlined,color: Colors.red,size: 80,),
                    SizedBox(height: 10,),
                    Text("Visitor Not Allowed",style: TextStyle(color: Colors.red,fontSize: 24,fontWeight: FontWeight.bold),)
                  ],
                )
            ),
          )
      ),
      //),
      bottomSheet: CustomBottomSheet(home: () {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            VisitorList()), (Route<dynamic> route) => false);
      }, qrScan: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ScanQR()));
      }),
    );
  }
}
