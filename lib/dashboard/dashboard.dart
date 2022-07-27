import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/dashboard/employee_document.dart';
import 'package:xtreme_fleet/dashboard/project_document.dart';
import 'package:xtreme_fleet/utilities/my_assets.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';
import 'package:xtreme_fleet/dashboard/menu_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  int indexColor = 50;
  int category = 0;

  var khataList;

  bool _loading = true;
  List<Map> color = [
    {
      'green': Color.fromRGBO(104, 191, 123, 1),
      'white': Color.fromRGBO(249, 251, 250, 1)
    }
  ];
  var selected;

  dashboardApi() async {
    try {
      Map body = {"type": "Dashboard_Transactions_AmountSum", "value": {}};
      var request = await http.post(
          Uri.parse('https://khata.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body));
      var decode = json.decode(request.body);

      if (request.statusCode == 200) {
        print('<<<<<<<<<>>>>>>>>>>>>>>>>>');

        khataList = json.decode(decode['Value']);

        print(khataList);

        print('<<<<<<<<<>>>>>>>>>>>>>>>>>');

        return khataList;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  callApis() async {
    khataList = await dashboardApi() ?? "";

    _loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callApis();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromRGBO(234, 239, 243, 1),
        key: _scaffold,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.title,
          leading: Container(
           
            
            child: InkWell(
              onTap: () {
                // print('gggggggggggggggggggggg');
                // _scaffold.currentState!.openDrawer();
              },
             
            ),
          ),
          title: Text(
            'Dashboard',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      //  drawer: MenuScreen(),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(
                  color: MyColors.cardtxtgreen,
                ),
              )
            : Container(
                padding: EdgeInsets.only(top: 10, bottom: 20,left: 5,right: 5),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () => setState(() {
                                      indexColor = 0;
                                      category = 0;
                                    }),
                                child: listCont(
                                    ' ${khataList["todayDr"]}'
                                        .split('.')
                                        .first,
                                    ' ${khataList["todayCr"]}'
                                        .split('.')
                                        .first,
                                    'Today Transactions',
                                    bgcolor: indexColor == 0
                                        ? MyColors.cardgreen
                                        : MyColors.cardwhite,
                                    textcolor: indexColor == 0
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardtxtwhite,
                                    icon: FontAwesomeIcons.calendarDay,
                                    iconcolor: indexColor == 0
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardgreen,
                                    countcolor: indexColor == 0
                                        ? MyColors.cardtxtgreen
                                        : MyColors.title,
                                    transacDate: 0.3)),
                            GestureDetector(
                                onTap: () => setState(() {
                                      indexColor = 1;
                                    }),
                                child: listCont(
                                    '${khataList["yesterdayDr"]}'
                                        .split('.')
                                        .first,
                                    '${khataList["yesterdayCr"]}'
                                        .split('.')
                                        .first,
                                    'Yesterday Transactions',
                                    bgcolor: indexColor == 1
                                        ? MyColors.cardgreen
                                        : MyColors.cardwhite,
                                    textcolor: indexColor == 1
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardtxtwhite,
                                    icon: FontAwesomeIcons.calendarMinus,
                                    iconcolor: indexColor == 1
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardgreen,
                                    countcolor: indexColor == 1
                                        ? MyColors.cardtxtgreen
                                        : MyColors.title,
                                    transacDate: 0.3)),
                          ],
                        ),
                      ),
                      //
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () => setState(() {
                                      indexColor = 2;
                                    }),
                                child: listCont(
                                    '${khataList["thisWeekDr"]}'
                                        .split('.')
                                        .first,
                                    '${khataList["thisWeekCr"]}'
                                        .split('.')
                                        .first,
                                    'This Week Transactions',
                                    bgcolor: indexColor == 2
                                        ? MyColors.cardgreen
                                        : MyColors.cardwhite,
                                    textcolor: indexColor == 2
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardtxtwhite,
                                    icon: FontAwesomeIcons.moneyBillTrendUp,
                                    iconcolor: indexColor == 2
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardgreen,
                                    countcolor: indexColor == 2
                                        ? MyColors.cardtxtgreen
                                        : MyColors.title,
                                    transacDate: 0.3)),
                            GestureDetector(
                                onTap: () => setState(() {
                                      indexColor = 3;
                                    }),
                                child: listCont(
                                    '${khataList["lastWeekDr"]}'
                                        .split('.')
                                        .first,
                                    '${khataList["lastWeekCr"]}'
                                        .split('.')
                                        .first,
                                    'Last Week Transactions',
                                    bgcolor: indexColor == 3
                                        ? MyColors.cardgreen
                                        : MyColors.cardwhite,
                                    textcolor: indexColor == 3
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardtxtwhite,
                                    icon: FontAwesomeIcons.moneyCheck,
                                    iconcolor: indexColor == 3
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardgreen,
                                    countcolor: indexColor == 3
                                        ? MyColors.cardtxtgreen
                                        : MyColors.title,
                                    transacDate: 0.3)),
                          ],
                        ),
                      ),
                      //
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () => setState(() {
                                      indexColor = 4;
                                      category = 0;
                                    }),
                                child: listCont(
                                    '${khataList["thisMonthDr"]}'
                                        .split('.')
                                        .first,
                                    '${khataList["thisMonthCr"]}'
                                        .split('.')
                                        .first,
                                    'This Month Transactions',
                                    bgcolor: indexColor == 4
                                        ? MyColors.cardgreen
                                        : MyColors.cardwhite,
                                    textcolor: indexColor == 4
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardtxtwhite,
                                    icon: FontAwesomeIcons.moneyBillTransfer,
                                    iconcolor: indexColor == 4
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardgreen,
                                    countcolor: indexColor == 4
                                        ? MyColors.cardtxtgreen
                                        : MyColors.title,
                                    transacDate: 0.3)),
                            GestureDetector(
                                onTap: () => setState(() {
                                      indexColor = 5;
                                    }),
                                child: listCont(
                                    '${khataList["lastMonthDr"]}'
                                        .split('.')
                                        .first,
                                    '${khataList["lastMonthCr"]}'
                                        .split('.')
                                        .first,
                                    'Last Month Transactions',
                                    bgcolor: indexColor == 5
                                        ? MyColors.cardgreen
                                        : MyColors.cardwhite,
                                    textcolor: indexColor == 5
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardtxtwhite,
                                    icon: FontAwesomeIcons.moneyCheckDollar,
                                    iconcolor: indexColor == 4
                                        ? MyColors.cardtxtgreen
                                        : MyColors.cardgreen,
                                    countcolor: indexColor == 5
                                        ? MyColors.cardtxtgreen
                                        : MyColors.title,
                                    transacDate: 0.3)),
                          ],
                        ),
                      ),
                      //
                      // Container(
                      //   height: 60,
                      //   child: Image.asset('assets/logo11.png'),
                      // ),
                      //  Container(
                      //   height: 60,
                      //   child: Image.asset('assets/logo.png'),
                      // ),
                     
                    ],
                  ),
                )));
  }

  textCont(String text, Color color, Color textcolor) {
    return Container(
      padding: EdgeInsets.only(top: 7, bottom: 7, right: 25, left: 25),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            // margin: EdgeInsets.only(bottom: 10),
            child: Text(
              text,
              style: TextStyle(
                  // decoration: TextDecoration.underline,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textcolor),
            ),
          ),
        ],
      ),
    );
  }

  listCont(String debit, String credit, String text,
      {Function? onTap,
      Color? bgcolor,
      Color? textcolor,
      IconData? icon,
      Color? iconcolor,
      Color? countcolor,
      double? transacDate,
      Color? valuecolor}) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Container(
        height: 160,
        width: 190,
        child: Stack(children: [
          Card(
            color: bgcolor,
            shadowColor: Colors.white.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
              side: BorderSide(color: MyColors.grey.withOpacity(0.1)),
            ),
            elevation: 50,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(),
                          child: Text(
                            'Debit :   ',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: MyColors.cardtxtwhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(),
                          child: Text(
                            debit,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: countcolor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(),
                          child: Text(
                            'Credit :  ',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: MyColors.cardtxtwhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(),
                          child: Text(
                            credit,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: countcolor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,

                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(
                      right: 15,
                    ),
                    //  padding: EdgeInsets.all(6),

                    decoration: BoxDecoration(),
                    child: FaIcon(
                      icon,
                      color: iconcolor,
                      size: 30,
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: textcolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
//                   Container(

//   child: LinearProgressIndicator(
//     value: transacDate,
//     backgroundColor: Color(0xffD6D6D6),
//     valueColor: AlwaysStoppedAnimation<Color>(MyColors.cardgreen),

//   ),
// )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
