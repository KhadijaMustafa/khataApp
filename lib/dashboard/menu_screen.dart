import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xtreme_fleet/dashboard/company_document.dart';
import 'package:xtreme_fleet/dashboard/customer_list.dart';
import 'package:xtreme_fleet/dashboard/dashboard.dart';
import 'package:xtreme_fleet/dashboard/emp_exp_report.dart';
import 'package:xtreme_fleet/dashboard/employee_expense.dart';
import 'package:xtreme_fleet/dashboard/employee_list.dart';
import 'package:xtreme_fleet/dashboard/khata_transaction_list.dart';
import 'package:xtreme_fleet/dashboard/monthly_rent.dart';
import 'package:xtreme_fleet/dashboard/new_khata_list.dart';
import 'package:xtreme_fleet/dashboard/project_list.dart';
import 'package:xtreme_fleet/dashboard/setup_site.dart';
import 'package:xtreme_fleet/dashboard/setup_vehicle_type.dart';
import 'package:xtreme_fleet/dashboard/trip_management_list.dart';
import 'package:xtreme_fleet/dashboard/trip_report.dart';
import 'package:xtreme_fleet/dashboard/veh_exp_report.dart';
import 'package:xtreme_fleet/dashboard/vehicle_expense.dart';
import 'package:xtreme_fleet/dashboard/vehicle_list.dart';
import 'package:xtreme_fleet/dashboard/vehicle_supplier.dart';
import 'package:xtreme_fleet/utilities/my_assets.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class MenuScreen extends StatefulWidget {
  MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int indexcolor = 50;
  String? dropDownValue;
  List<String> account = [
    'Vehicle Expense',
    'Employee Expense',
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      
        backgroundColor: Color.fromRGBO(234, 239, 243, 1),
        child: Container(
          // color: Colors.white,
          child: SingleChildScrollView(
            // margin: EdgeInsets.only(left: 15),
            //,
            child: Column(
              children: [
                 SizedBox(
                        child: Container(
                          color: MyColors.title,
                          height: 30,
                        ),
                      ),
                Container(
                  // height: 80,
                  color: MyColors.title,
                  // margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     
                      Container(
                        margin: EdgeInsets.only(left: 15, ),
                        height: 35,
                        child: Image.asset(MyAssets.whitelogo),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 40,
                          margin: EdgeInsets.only(right: 15, top: 10),
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.close,
                            color: MyColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      indexcolor = 29;
                    });
                    MyNavigation().push(context, Dashboard());
                  },
                  child: Container(
                    child: menuCont(
                      FontAwesomeIcons.cruzeiroSign,
                      'Dashboard',
                      EdgeInsets.only(left: 12, top: 25),
                      FontWeight.bold,
                      16,
                      18,
                      iconcolor:
                          indexcolor == 29 ? MyColors.title : MyColors.dgreen,
                      textcolor:
                          indexcolor == 29 ? MyColors.title : MyColors.dgreen,
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       indexcolor = 0;
                //     });
                //     MyNavigation().push(context, CompanyDocument());
                //   },
                //   child: Container(
                //     child: menuCont(
                //       FontAwesomeIcons.file,
                //       'Company Document',
                //       EdgeInsets.only(left: 12, top: 20),
                //       FontWeight.bold,
                //       16,
                //       20,
                //       iconcolor: indexcolor == 0 ? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 0 ? MyColors.yellow : MyColors.black,
                //     ),
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       indexcolor = 1;
                //     });
                //     MyNavigation().push(context, EmployeeList());
                //   },
                //   child: Container(
                //     child: menuCont(FontAwesomeIcons.user, 'Employee',
                //         EdgeInsets.only(left: 12, top: 20), FontWeight.bold, 16, 20,
                //        iconcolor: indexcolor == 1? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 1 ? MyColors.yellow : MyColors.black,),
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //       setState(() {
                //       indexcolor = 2;
                //     });
                //     MyNavigation().push(context, CustomerList());
                //   },
                //   child: Container(
                //     child: menuCont(FontAwesomeIcons.userLarge, 'Customer',
                //         EdgeInsets.only(left: 12, top: 20), FontWeight.bold, 16, 18,    iconcolor: indexcolor == 2? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 2 ? MyColors.yellow : MyColors.black,),
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //       setState(() {
                //       indexcolor = 3;
                //     });
                //     MyNavigation().push(context, VehicleSupplier());
                //   },
                //   child: Container(
                //     child: menuCont(FontAwesomeIcons.userTie, 'Vehicle Supplier',
                //         EdgeInsets.only(left: 12, top: 20), FontWeight.bold, 16, 20,
                //             iconcolor: indexcolor == 3? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 3? MyColors.yellow : MyColors.black, ),
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //       setState(() {
                //       indexcolor = 4;
                //     });
                //     MyNavigation().push(context, VehicleList());
                //   },
                //   child: Container(
                //     child: menuCont(FontAwesomeIcons.carRear, 'Vehicle ',
                //         EdgeInsets.only(left: 17, top: 20), FontWeight.bold, 16, 18,
                //             iconcolor: indexcolor == 4? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 4 ? MyColors.yellow : MyColors.black,
                //         ),
                //   ),
                // ),
                // InkWell(
                //   onTap: () {
                //       setState(() {
                //       indexcolor = 5;
                //     });
                //     MyNavigation().push(context, ProjectList());
                //   },
                //   child: Container(
                //     child: menuCont(FontAwesomeIcons.productHunt, 'Project',
                //         EdgeInsets.only(left: 12, top: 20), FontWeight.bold, 16, 20,
                //             iconcolor: indexcolor == 5? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 5 ? MyColors.yellow : MyColors.black,
                //         ),
                //   ),
                // ),
                // Theme(
                //   data: ThemeData().copyWith(dividerColor: Colors.transparent),
                //   child: ExpansionTile(
                //       iconColor: MyColors.yellow,
                //       collapsedIconColor: MyColors.black,
                //       expandedAlignment: Alignment.center,
                //       title: menuCont(
                //           FontAwesomeIcons.barsProgress,
                //           'Trip Management ',
                //           EdgeInsets.only(top: 20),
                //           FontWeight.bold,
                //           16,
                //           20,    iconcolor: indexcolor == 6 || indexcolor==7? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 6 || indexcolor==7 ? MyColors.yellow : MyColors.black,),
                //       children: [
                //         InkWell(
                //           onTap: () {
                //               setState(() {
                //       indexcolor = 6;
                //     });
                //             MyNavigation().push(context, TripManagement());
                //           },
                //           child: Container(
                //             child: menuCont(
                //                 FontAwesomeIcons.carSide,
                //                 'Trip',
                //                 EdgeInsets.only(left: 50, top: 10),
                //                 FontWeight.w400,
                //                 14,
                //                 16,    iconcolor: indexcolor == 6? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 6? MyColors.yellow : MyColors.black,),
                //           ),
                //         ),
                //         InkWell(
                //           onTap: () {
                //             setState(() {
                //               indexcolor=7;
                //             });
                //             MyNavigation().push(context, TripReport());
                //           },
                //           child: Container(
                //             child: menuCont(
                //                 FontAwesomeIcons.fileImport,
                //                 'Trip Report',
                //                 EdgeInsets.only(left: 50, top: 10),
                //                 FontWeight.w400,
                //                 14,
                //                 16,iconcolor: indexcolor == 7? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 7? MyColors.yellow : MyColors.black,),
                //           ),
                //         ),
                //       ]),
                // ),
                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       indexcolor=8;
                //     });
                //     MyNavigation().push(context, MonthlyRent());
                //   },
                //   child: Container(
                //     child: menuCont(FontAwesomeIcons.truck, 'Monthly Rent',
                //         EdgeInsets.only(left: 12, top: 20), FontWeight.bold, 16, 20,iconcolor: indexcolor == 8? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 8? MyColors.yellow : MyColors.black,),
                //   ),
                // ),
                Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      iconColor: MyColors.title,
                      collapsedIconColor: MyColors.black,
                      expandedAlignment: Alignment.center,
                      title: menuCont(
                        FontAwesomeIcons.moneyCheckDollar,
                        'Khata ',
                        EdgeInsets.only(top: 20),
                        FontWeight.bold,
                        16,
                        18,
                        iconcolor: indexcolor == 9 ||
                                indexcolor == 10 ||
                                indexcolor == 30
                            ? MyColors.title
                            : MyColors.dgreen,
                        textcolor: indexcolor == 9 ||
                                indexcolor == 10 ||
                                indexcolor == 30
                            ? MyColors.title
                            : MyColors.dgreen,
                      ),
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              indexcolor = 9;
                            });
                            MyNavigation().push(context, NewKhataList());
                          },
                          child: Container(
                            child: menuCont(
                              FontAwesomeIcons.plus,
                              'New Khata',
                              EdgeInsets.only(left: 50, top: 10),
                              FontWeight.w400,
                              14,
                              16,
                              iconcolor: indexcolor == 9
                                  ? MyColors.title
                                  : MyColors.dgreen,
                              textcolor: indexcolor == 9
                                  ? MyColors.title
                                  : MyColors.dgreen,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              indexcolor = 10;
                            });
                            MyNavigation()
                                .push(context, KhataTransactionList());
                          },
                          child: Container(
                            child: menuCont(
                              FontAwesomeIcons.plus,
                              'Add Transaction',
                              EdgeInsets.only(left: 50, top: 10),
                              FontWeight.w400,
                              14,
                              16,
                              iconcolor: indexcolor == 10
                                  ? MyColors.title
                                  : MyColors.dgreen,
                              textcolor: indexcolor == 10
                                  ? MyColors.title
                                  : MyColors.dgreen,
                            ),
                          ),
                        ),
                      ]),
                ),
                //////
                // Theme(
                //   data: ThemeData().copyWith(dividerColor: Colors.transparent),
                //   child: ExpansionTile(
                //       iconColor: MyColors.yellow,
                //       collapsedIconColor: MyColors.black,
                //       expandedAlignment: Alignment.center,
                //       title: menuCont(FontAwesomeIcons.fileInvoice, 'Account ',
                //           EdgeInsets.only(top: 20), FontWeight.bold, 16, 20,
                //            iconcolor: indexcolor == 11 || indexcolor==12 || indexcolor==13|| indexcolor==14? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 11 || indexcolor==12 || indexcolor==13|| indexcolor==14?  MyColors.yellow : MyColors.black,),
                //       children: [
                //         InkWell(
                //           onTap: () {
                //             setState(() {
                //               indexcolor=11;
                //             });
                //             MyNavigation().push(context, VehicleExpense());
                //           },
                //           child: Container(
                //             child: menuCont(
                //                 FontAwesomeIcons.carSide,
                //                 'Vehicle Expense',
                //                 EdgeInsets.only(left: 50, top: 10),
                //                 FontWeight.w400,
                //                 14,
                //                 16,iconcolor: indexcolor == 11? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 11? MyColors.yellow : MyColors.black,),
                //           ),
                //         ),
                //         InkWell(
                //           onTap: () {
                //             setState(() {
                //               indexcolor=12;
                //             });
                //             MyNavigation().push(context, EmployeeExpense());
                //           },
                //           child: Container(
                //             child: menuCont(
                //                 FontAwesomeIcons.userGroup,
                //                 'Employee Expense',
                //                 EdgeInsets.only(left: 50, top: 10),
                //                 FontWeight.w400,
                //                 14,
                //                 16,iconcolor: indexcolor == 12? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 12? MyColors.yellow : MyColors.black,),
                //           ),
                //         ),
                //         InkWell(
                //           onTap: () {
                //             setState(() {
                //               indexcolor=13;
                //             });
                //             MyNavigation().push(context, VehicleExpenseReport());
                //           },
                //           child: Container(
                //             child: menuCont(
                //                 FontAwesomeIcons.fileImport,
                //                 'Vehicle Expense Report',
                //                 EdgeInsets.only(left: 50, top: 10),
                //                 FontWeight.w400,
                //                 14,
                //                 16,iconcolor: indexcolor == 13? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 13? MyColors.yellow : MyColors.black,),
                //           ),
                //         ),
                //         InkWell(
                //           onTap: () {
                //             setState(() {
                //               indexcolor=14;
                //             });
                //             MyNavigation().push(context, EmployeeExpenseReport());
                //           },
                //           child: Container(
                //             margin: EdgeInsets.only(bottom: 30),
                //             child: menuCont(
                //                 FontAwesomeIcons.fileImport,
                //                 'Employee Expense Report',
                //                 EdgeInsets.only(left: 50, top: 10),
                //                 FontWeight.w400,
                //                 14,
                //                 16,iconcolor: indexcolor == 14? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 14? MyColors.yellow : MyColors.black,),
                //           ),
                //         ),
                //       ]),
                // ),
                // Theme(
                //   data: ThemeData().copyWith(dividerColor: Colors.transparent),
                //   child: ExpansionTile(
                //       iconColor: MyColors.yellow,
                //       collapsedIconColor: MyColors.black,
                //       expandedAlignment: Alignment.center,
                //       title: menuCont(FontAwesomeIcons.gear, 'SetUps ',
                //           EdgeInsets.only(top: 20), FontWeight.bold, 16, 20,   iconcolor: indexcolor == 15 || indexcolor==16 ? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 15 || indexcolor==16?  MyColors.yellow : MyColors.black,),
                //       children: [
                //         InkWell(
                //           onTap: () {
                //             setState(() {
                //               indexcolor=15;
                //             });
                //             MyNavigation().push(context, SetUpSite());
                //           },
                //           child: Container(
                //             child: menuCont(
                //                 FontAwesomeIcons.locationDot,
                //                 'Site',
                //                 EdgeInsets.only(left: 50, top: 10),
                //                 FontWeight.w400,
                //                 14,
                //                 16,iconcolor: indexcolor == 15? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 15? MyColors.yellow : MyColors.black,),
                //           ),
                //         ),
                //         InkWell(
                //           onTap: () {
                //              setState(() {
                //               indexcolor=16;
                //             });
                //             MyNavigation().push(context, SetUpVehicleType());
                //           },
                //           child: Container(
                //             child: menuCont(
                //                 FontAwesomeIcons.locationDot,
                //                 'Vahicle Type',
                //                 EdgeInsets.only(left: 50, top: 10),
                //                 FontWeight.w400,
                //                 14,
                //                 16,iconcolor: indexcolor == 16? MyColors.yellow : MyColors.black,
                //       textcolor: indexcolor == 16? MyColors.yellow : MyColors.black,),
                //           ),
                //         ),
                //       ]),
                // ),
              ],
            ),
          ),
        ));
  }

  menuCont(IconData, String text, EdgeInsetsGeometry margen,
      FontWeight fontWeight, double size, double iconsize,
      {Color? iconcolor, Color? textcolor, Color? bgcolor}) {
    return Container(
      color: bgcolor,
      margin: margen,
      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(right: 17),
              child: Icon(
                IconData,
                size: iconsize,
                color: iconcolor,
              )),
          Expanded(
            child: Container(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: size, fontWeight: fontWeight, color: textcolor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
