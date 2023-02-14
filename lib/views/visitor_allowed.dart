import 'package:flutter/material.dart';
import 'package:passwise_security/constants/custom_colors.dart';
import 'package:passwise_security/models/scaned_visitor_model.dart';
import 'package:passwise_security/views/scan_qr.dart';
import 'package:passwise_security/views/visitor_list.dart';
import 'package:passwise_security/widgets/custom_bottom_sheet.dart';
import 'package:passwise_security/widgets/our_scaffold.dart';

class VisitorAllowed extends StatefulWidget {
  ScannedVisitorModel scannedVisitorModel;
  VisitorAllowed({Key? key,required this.scannedVisitorModel}) : super(key: key);

  @override
  State<VisitorAllowed> createState() => _VisitorAllowedState();
}

class _VisitorAllowedState extends State<VisitorAllowed> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            VisitorList()), (Route<dynamic> route) => false);
        return await false;
      },
      child: OurScaffoldTemplate(
        showFAB: false,
        appBarWidget: Column(
          children: [
            AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text("Success"),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text("Success"),
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
                  children: [
                    Text("Successfully Scan",style: TextStyle(color: CustomColors().customBlueColor,fontWeight: FontWeight.bold,fontSize: 25),textAlign: TextAlign.center,),
                    SizedBox(height: 5,),
                widget.scannedVisitorModel.image!.isEmpty ?
                CircleAvatar(
                  backgroundImage: AssetImage("assets/logo/logo.png"),
                radius: 50,
              ):
                CircleAvatar(
                  backgroundImage:
                  NetworkImage(widget.scannedVisitorModel.image!),
                      radius: 50,
                    ),

                    SizedBox(height: 5,),
                    Text(widget.scannedVisitorModel.name??"Name",style: TextStyle(fontWeight: FontWeight.bold,color: CustomColors().customTextDarkGrey),),
                    SizedBox(height: 5,),
                    Text(widget.scannedVisitorModel.phoneNo??"Phone No",style: TextStyle(fontWeight: FontWeight.bold,color: CustomColors().customTextDarkGrey),),
                    SizedBox(height: 5,),
                    Text(widget.scannedVisitorModel.cnic??"CNIC",style: TextStyle(fontWeight: FontWeight.bold,color: CustomColors().customTextDarkGrey),),
                    SizedBox(height: 5,),
                    Text("Company",style: TextStyle(fontWeight: FontWeight.bold,color: CustomColors().customTextDarkGrey),),
                    SizedBox(height: 15,),
                    Text(widget.scannedVisitorModel.reason??"Reason",style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,),
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
      ),
    );
  }
}
