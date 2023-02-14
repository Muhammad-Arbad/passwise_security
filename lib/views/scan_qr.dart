import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:passwise_security/constants/custom_colors.dart';
import 'package:passwise_security/models/scaned_visitor_model.dart';
import 'package:passwise_security/scrvices/http_request.dart';
import 'package:passwise_security/views/visitor_allowed.dart';
import 'package:passwise_security/views/visitor_not_allowed.dart';
import 'package:passwise_security/widgets/custom_bottom_sheet.dart';
import 'package:passwise_security/widgets/our_scaffold.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';



class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcodeScanResult;
  QRViewController? controller;
  HttpRequest sendScanedQRdata = HttpRequest();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return OurScaffoldTemplate(
      showFAB: isLoading==false?true:false,
      fabOnPress: (){
        print("Inside FAB");
        // HapticFeedback.heavyImpact();
        },
      appBarWidget: Column(
        children: [
          AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text("Scan QR Code"),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("Scan QR Code"),
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
      bodyWidget: isLoading==false?
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              50,
              20,
              50,
              10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(alignment: Alignment.center, children: [
                Container(
                  width: 270,
                  height: 270,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/qr_scan.png"))),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child:barcodeScanResult!=null?
                    Container(
                    child: Center(child: Text("Scanned Successfuly",style: TextStyle(color: CustomColors().customBlueColor),)),
                    ):
                    buildQrView(context),
                  ),
                ),
              ]),
              //),

              SizedBox(
                height: 30,
              ),

              Text(
                "Align QR code within",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "frame to scan",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ):
      Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: CustomColors().customBlueColor,),
      ),
      bottomSheet: isLoading==false?CustomBottomSheet(home: () {Navigator.pop(context);},
          qrScan: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => super.widget));}):null,
    );
  }


  buildQrView(BuildContext context) => QRView(
    key: qrKey,
    onQRViewCreated: _onQRViewCreated,
  );

  void _onQRViewCreated(QRViewController controller) {
    // setState(() {
    //   this.controller = controller;
    // });
    controller.scannedDataStream.listen((scanData) async{

      //setState(() {

        barcodeScanResult = scanData;
        print('barcodeScanResult');
        print(barcodeScanResult!.code.toString());
        controller?.dispose();
        // HapticFeedback.heavyImpact();
        isLoading = true;

        setState(() {});
        var data = await sendScanedQRdata.scanQR(barcodeScanResult!.code.toString());
        //isLoading =false;



        setState(() {});
        if(data!="Not allowed"){
          ScannedVisitorModel scannedVisitorModel = ScannedVisitorModel.fromJson(jsonDecode(data)['data']);
          print("Network Image = "+scannedVisitorModel.image.toString());
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VisitorAllowed(scannedVisitorModel: scannedVisitorModel,)));
        }else
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VisitorNotAllowed()));
          }
        // });





    });
  }

  @override
  void dispose() {
    print("Dispose method called");
    controller?.dispose();
    super.dispose();
  }
}
