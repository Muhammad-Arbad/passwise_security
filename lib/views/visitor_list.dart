import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:passwise_security/constants/custom_colors.dart';
import 'package:passwise_security/models/visitor_details_Model.dart';
import 'package:passwise_security/scrvices/http_request.dart';
import 'package:passwise_security/sharedPreferences/user_preferences.dart';
import 'package:passwise_security/views/scan_qr.dart';
import 'package:passwise_security/views/sign_in.dart';
import 'package:passwise_security/widgets/custom_bottom_sheet.dart';
import 'package:table_calendar/table_calendar.dart';


class VisitorList extends StatefulWidget {

  VisitorList({Key? key}) : super(key: key);

  @override
  State<VisitorList> createState() => _VisitorListState();
}

class _VisitorListState extends State<VisitorList> {
  int selectedIndex = 0,currentPageDate = 0,previousIndex = 0;
  bool isLoading = false;
  HttpRequest getPassesHttp = HttpRequest();
  DateTime selectedDate = DateTime.now();
  int selectedDateFromCalendar = DateTime.now().day;
  List<VisitorsDetailModel> sortedVisitorsList = [];
  List<VisitorsDetailModel> allVisitorsList = [];
  bool showSearchBar = false;
  String searchString = "",companyName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companyName = UserPreferences.getCompanyName()??"Office Name";
    getAllPasses();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        color: CustomColors().customBlueColor,
        padding: const EdgeInsets.only(left: 10),
        child: Scaffold(
          backgroundColor: CustomColors().customWhiteColor,
          appBar: AppBar(
            leading:
            IconButton(
                icon: Icon(Icons.logout_outlined,
                    size: 30, color: CustomColors().customBlueColor),
                onPressed: () {

                  wahtToLogOut(context);
                  // UserPreferences.setUserToken("null");
                  // // UserPreferences.clearAllPreferences();
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => Sign_In_Up()));
                  // Fluttertoast.showToast(msg: "Loged Out",gravity: ToastGravity.CENTER,backgroundColor: CustomColors().customGreenColor);
                }),
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(
            //       Icons.search,
            //       size: 30,
            //       color: !showSearchBar
            //           ? CustomColors().customBlueColor
            //           : CustomColors().customWhiteColor,
            //     ),
            //     onPressed: () {
            //       setState(() {
            //         showSearchBar = true;
            //         sortedVisitorsList = allVisitorsList;
            //       });
            //     },
            //   ),
            // ],
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              "Visitor List",
              style: TextStyle(
                  color: CustomColors().customBlueColor,
                  fontWeight: FontWeight.bold),
            ),
            // Column(
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           "Visitor List",
            //           style: TextStyle(
            //               color: CustomColors().customBlueColor,
            //               fontWeight: FontWeight.bold),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                  height: 2.0,
                  width: 50.0,
                  color: CustomColors().customBlueColor),
            ),
          ),
          body: !isLoading
              ? Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                      //   child: CalendarAppBar(),
                      // ),
                      Container(
                          //height: 400,
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child:
                          //showSearchBar ? showSearchField() :
                          horizontalCalendar()
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: sortedVisitorsList.length,
                          itemBuilder: (context, index) {
                            return singleVisitorTile(
                                sortedVisitorsList[index], index);
                          },
                        ),
                      ),
                    ],
                  ),
                  color: CustomColors().customWhiteColor,
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: CustomColors().customBlueColor,
                )),
          bottomSheet: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            color: CustomColors().customWhiteColor,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                color: CustomColors().customBlueColor,
              ),
              child: CustomBottomSheet(
                  qrScan: scanQR,
                  home: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => super.widget));
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (showSearchBar == true) {
      sortByDate();
      setState(() {
        showSearchBar = false;
      });
      return await false;
    } else {
      return await true;
    }
  }

  void getAllPasses() async {
    //print(DateTime.now());

    setState(() {
      isLoading = true;
    });

    print("Token = "+UserPreferences.getUserToken().toString());
    List data = await getPassesHttp.getAllPasses(UserPreferences.getUserToken()??"");
    for (int i = 0; i < data.length; i++) {
      allVisitorsList.add(VisitorsDetailModel.fromJson(data[i]));
    }
    sortedVisitorsList = allVisitorsList;

    sortByDate();
  }

  Widget singleVisitorTile(VisitorsDetailModel visitorsDetail, int index) {
    previousIndex = index - 1;
    return GestureDetector(
      onTap: () => setState(
        () {
          selectedIndex = index;
          currentPageDate = selectedDate.day;
        },
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  previousIndex >= 0
                      ? Column(
                          children: [
                            Text(
                                int.parse(displayOnlyHours(visitorsDetail.date)) <=
                                        12
                                    ? displayOnlyHours(visitorsDetail.date)
                                    : (int.parse(displayOnlyHours(
                                                visitorsDetail.date)) -
                                            12)
                                        .toString(),
                                style: TextStyle(
                                    color: int.parse(displayOnlyHours(
                                                sortedVisitorsList[index]
                                                    .date)) ==
                                            int.parse(displayOnlyHours(
                                                sortedVisitorsList[previousIndex].date))
                                        ? CustomColors().customWhiteColor
                                        : CustomColors().customTextGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                int.parse(displayOnlyHours(
                                            visitorsDetail.date)) <=
                                        12
                                    ? "AM"
                                    : "PM",
                                style: TextStyle(
                                    color: int.parse(displayOnlyHours(
                                                sortedVisitorsList[index]
                                                    .date)) ==
                                            int.parse(displayOnlyHours(
                                                sortedVisitorsList[
                                                        previousIndex]
                                                    .date))
                                        ? CustomColors().customWhiteColor
                                        : CustomColors().customTextGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                                int.parse(displayOnlyHours(
                                            visitorsDetail.date)) <=
                                        12
                                    ? displayOnlyHours(visitorsDetail.date)
                                    : (int.parse(displayOnlyHours(
                                                visitorsDetail.date)) -
                                            12)
                                        .toString(),
                                style: TextStyle(
                                    color: CustomColors().customTextGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                int.parse(displayOnlyHours(
                                            visitorsDetail.date)) <=
                                        12
                                    ? "AM"
                                    : "PM",
                                style: TextStyle(
                                    color: CustomColors().customTextGrey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      (selectedIndex == index && currentPageDate==selectedDateFromCalendar)
                          ? Container(
                              child: CustomPaint(
                                size: Size(13, 13),
                                painter: CirclePainterFilled(),
                              ),
                            )
                          : CustomPaint(
                              size: Size(13, 13),
                              painter: CirclePainter(),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 55,
                        child: VerticalDivider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: (selectedIndex == index && currentPageDate==selectedDateFromCalendar)
                        ? CustomColors().customBlueColor
                        : CustomColors().customTileColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: kElevationToShadow[4],
                  ),
                  //padding: EdgeInsets.all(5),
                  padding: EdgeInsets.fromLTRB(5, 5, 30, 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.calendar_month_outlined,
                            color: CustomColors().customWhiteColor,
                          )),
                      Expanded(
                          flex: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    visitorsDetail.reason!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color:(selectedIndex == index && currentPageDate==selectedDateFromCalendar)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    displayHourAndMinutes(visitorsDetail.date),
                                    style: TextStyle(
                                      color: (selectedIndex == index && currentPageDate==selectedDateFromCalendar)
                                          ? Colors.white
                                          : CustomColors().customTextGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(visitorsDetail.name ?? "",
                                      style: TextStyle(
                                        //color: CustomColors().customTextGrey,
                                        fontSize: 12,
                                        color: (selectedIndex == index && currentPageDate==selectedDateFromCalendar)
                                            ? Colors.white
                                            : CustomColors().customTextGrey,
                                      )),
                                  Text(visitorsDetail.phoneNo ?? "",
                                      style: TextStyle(
                                          //color: CustomColors().customTextGrey,
                                          color: (selectedIndex == index && currentPageDate==selectedDateFromCalendar)
                                              ? Colors.white
                                              : CustomColors().customTextGrey,
                                          fontSize: 12)),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                companyName,
                                style: TextStyle(
                                    color: (selectedIndex == index && currentPageDate==selectedDateFromCalendar)
                                        ? Colors.white
                                        : CustomColors().customTextGrey,
                                    //color: CustomColors().customTextGrey,
                                    fontSize: 12),
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  String displayHourAndMinutes(String? date) {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date!);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputDate = DateFormat.Hm().format(inputDate);
    return outputDate;
  }

  String displayOnlyHours(String? date) {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date!);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputDate = DateFormat.H().format(inputDate);
    return outputDate;
  }

  String displayOnlyDate(String? date) {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date!);
    var inputDate = DateTime.parse(parseDate.toString());
    // print("inputDate" + inputDate.toString());
    //var outputDate = DateFormat.H().format(inputDate);
    var outputDate = DateFormat.d().format(inputDate);
    // print("outputDate"+outputDate);
    return outputDate;
  }

  DateTime stringToDateTime(String? date) {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date!);
    return parseDate;
  }

  horizontalCalendar() {
    return SingleChildScrollView(
      child: TableCalendar(
        calendarBuilders: CalendarBuilders(
          markerBuilder: ((context, day, events) {
            if (day.day == selectedDate.day &&
                day.month == selectedDate.month &&
                day.year == selectedDate.year ) {
              return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 3.0,
                  width: 23.0,
                  color: CustomColors().customBlueColor);
            }
          }),
          defaultBuilder: (context, dateTime, datetime) {
            if (dateTime.day == selectedDate.day &&
                dateTime.month == selectedDate.month) {
              return Center(
                child: Text(
                  dateTime.day.toString(),
                  style: TextStyle(color: CustomColors().customBlueColor),
                ),
              );
            } else {
              return Center(
                child: Text(
                  dateTime.day.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          },
          dowBuilder: (context, day) {
            final text = DateFormat('EEE').format(day);
            if (day.day == selectedDate.day &&
                day.month == selectedDate.month&&
                day.year == selectedDate.year) {
              return Center(
                child: Text(
                  text,
                  style: TextStyle(color: CustomColors().customBlueColor),
                ),
              );
            } else {
              return Center(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          },
        ),
        calendarStyle: CalendarStyle(),
        headerVisible: false,
        calendarFormat: CalendarFormat.week,
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 1, 1),
        focusedDay: selectedDate,
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (date, events) {
          selectedDate = date;
          selectedDateFromCalendar = date.day;

          sortByDate();
          setState(() {});
        },
      ),
    );
  }

  scanQR() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQR()));
  }

  //List<VisitorsDetailModel>
  void sortByDate() {
    final listData = allVisitorsList.where((element) {
      DateTime parseDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(element.date!);
      var inputDate = DateTime.parse(parseDate.toString());
      if (inputDate.month == selectedDate.month &&
          inputDate.day == selectedDate.day) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setState(() {
      isLoading = false;
      sortedVisitorsList = listData;
      sortedVisitorsList.sort((a, b) {
        // print(int.parse(displayOnlyHours(a.date)).toString()+" aa");
        // print(int.parse(displayOnlyHours(b.date)).toString()+" bb");
        return int.parse(displayOnlyHours(a.date))
            .compareTo(int.parse(displayOnlyHours(b.date)));
      });
    });
  }

  void sortBySearchString(String searchData) {
    final listData = allVisitorsList.where((element) {
      if (element.name!.toLowerCase().contains(searchData.toLowerCase()))
        return true;
      else
        return false;
    }).toList();

    setState(() {
      isLoading = false;
      sortedVisitorsList = listData;
    });
  }

  // showSearchField() {
  //   return Container(
  //     child: TextFormFieldCustomerBuiltSearch(
  //       showSeparator: false,
  //       icoon: Icons.search,
  //       onChange: (value) {
  //         setState(() {
  //           sortBySearchString(value);
  //         });
  //       },
  //     ),
  //   );
  // }

  void wahtToLogOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Do you want to Log out ?'),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("No",style: TextStyle(color: CustomColors().customBlueColor),)),
            TextButton(onPressed: ()async{
              UserPreferences.clearAllPreferences();
              Navigator.pop(context);
              setState(() {
                isLoading = true;
              });
              await Future.delayed(Duration(milliseconds: 500));
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  SignIn()), (Route<dynamic> route) => false);
              Fluttertoast.showToast(msg: "Loged Out",gravity: ToastGravity.CENTER,backgroundColor: CustomColors().customBlueColor);

            }, child: Text("Yes",style: TextStyle(color: CustomColors().customBlueColor))),

          ],
        )
    );
  }
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = CustomColors().customBlueColor
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CirclePainterFilled extends CustomPainter {
  final _paint = Paint()
    ..color = CustomColors().customBlueColor
    //..strokeWidth = 1
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

