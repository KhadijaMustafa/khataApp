import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:xtreme_fleet/dashboard/file_attachment.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';
import 'package:xtreme_fleet/utilities/notification_util.dart';

class TripReport extends StatefulWidget {
  TripReport({Key? key}) : super(key: key);

  @override
  State<TripReport> createState() => _TripReportState();
}

class _TripReportState extends State<TripReport> {
  DateTime startDate = DateTime.utc(2022);
  DateTime endDate = DateTime.now();
  List filterList = [];
  bool isSearching = false;
  bool _loading = true;
  List tripreportList = [];
    bool isDownloading = false;
    var selectedItem;
  int itemIndex = 0;
  double remaining = 0.0;
  double rate = 0.0;
  double expense = 0.0;


   showMessage(String title, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(title)));
  }

  tripReports() async {
    print("StartDate" + CusDateFormat.getDate(startDate));
    print("EndDate" + CusDateFormat.getDate(endDate));
    // return;
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "TripReport_GetByDateRange",
        "value": {
          "StartDate": CusDateFormat.getDate(startDate),
          "EndDate": CusDateFormat.getDate(endDate),
          "Language": "en-US"
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('StatusCode');
        print(decode);
        return json.decode(decode['Value']);
      }
    } catch (e) {}
  }

  vehicleReport() async {
    tripreportList = await tripReports();
calculateTotal();
    setState(() {});
    _loading = false;
  }

  @override
  void initState() {
    super.initState();
    vehicleReport();
  }
 

  void exportxlsx(List li) async {
    setState(() {
      isDownloading = true;
    });
    try {
      var excel = Excel.createExcel();
      String path = Directory('/storage/emulated/0/Download').path;
      List<String> keys = [];
      var sheet = excel['Sheet1'];
    
      keys.addAll(['name', 'expenseType', 'expenseDate', 'amount', 'remarks']);
      List<String> alpha = [
        'A',
        'B',
        'C',
        'D',
        'E',
        'F',
        'G',
        'H',
        'I',
        'J',
        'K',
        'L',
        'M',
        'N',
        'O',
        'P',
        'Q',
        'R',
        'S',
        'T',
        'U',
        'V',
        'W',
        'X',
        'Y',
        'Z'
      ];
      for (var i = 0; i < keys.length; i++) {
        var id = sheet.cell(CellIndex.indexByString("${alpha[i]}1"));
        id.value = keys[i];
      }
      for (var i = 0; i < li.length; i++) {
        for (var j = 0; j < keys.length; j++) {
          var id = sheet.cell(CellIndex.indexByString("${alpha[j]}${i + 2}"));
          id.value = li[i][keys[j]];
        }
      }
     
      var documentDirectory = await getExternalStorageDirectory();
      var parent = documentDirectory!.path;

      String fileName = '$parent/employeeList.xlsx';
      excel.encode().then((onValue) {
        print(true);
        File(fileName)
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      });
      setState(() {
        isDownloading = false;
      });
      NotificationUtil.showNotificationImportance(
          3, NotificationImportance.Default);
      showMessage(
        'Download Successful',
        MyColors.bggreen,
      );

      print('Excel');
      ;
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      showMessage('Some error occured please try again', MyColors.bgred);
    }
  }
   calculateTotal() {
    tripreportList.forEach((element) {
      remaining = remaining + element['remainingExpense'];
      rate = rate + element['projectTripRate'];
      expense = expense + element['tripExpense'];
      print(rate);
      print('totalAmount');

      setState(() {});
    });
  }//total


  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
       bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(8),
          height: 80,
          color: MyColors.yellow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      margin: EdgeInsets.only(left: 15),
                      child: textCont(
                        'Trip Rate :',
                        14,
                      ),
                    ),
                    Container(
               
                        child: textCont('$rate', 16, color: MyColors.red)),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 15),
                        child: textCont(
                          'Expense :',
                          14,
                        )),
                    Container(
                  
                      child: textCont('$expense', 16, color: MyColors.red),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: textCont(
                        'Remaining :',
                        14,
                      ),
                    ),
                    Container(
                    
                        child:
                            textCont('$remaining', 16, color: MyColors.red)),
                  ],
                ),
              )

             
            ],
          ),
        ),
      ),
      appBar: AppBar(
         elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Trip Report',
          style: TextStyle(color: Colors.white),
        ),
         actions: [
           InkWell(
                  onTap: () {
                    if (!isDownloading) {
                      exportxlsx(tripreportList);
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors.yellow,
                      ),
                      margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Container(
                              child: Icon(
                            Icons.file_download,
                            color: Colors.white,
                          )),
                          Container(
                            height: 30,
                            width: 30,
                            padding: EdgeInsets.all(5),
                            child: isDownloading
                                ? CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 1.0,
                                  )
                                : Container(
                                    height: 0,
                                    width: 0,
                                  ),
                          )
                        ],
                      )),
                )]
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              width: width,
                      margin: EdgeInsets.only(top: 15),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  dateCont(
                      '${CusDateFormat.getDate(startDate)}',
                      (date) => setState(() {
                            startDate = date;
                          })),
                          dateCont(
                      '${CusDateFormat.getDate(endDate)}',
                      (date) => setState(() {
                            endDate = date;
                          })),
                            InkWell(
                            onTap: () {
                              tripReports();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColors.yellow),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          )
                ],
              ),
            ),

              SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      width: width + 660,
                      child: Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.only(left: 10),
                            color: Color.fromARGB(255, 234, 227, 227),
                            child: tripListCont(
                                '#',
                                ' Trip #',
                                'Trip Date',
                                'Manifesto#',
                                'Plate #',
                                'P. Code',
                               
                                'DM/TC',
                                'Trip Rate','Expense','Remaining ',
                                15,
                                FontWeight.bold),
                          ),
                          Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount:  tripreportList.length,
                              itemBuilder: (BuildContext context, int index) {
                                int indexx = index + 1;
                                var item =  tripreportList[index];
                                return tripListCont(
                                  '$indexx',
                                  '${item['tripNumber']}',
                                  '${item['tripDate']}',
                                  '${item['manifestoNumber']}',
                                  '${item['vehiclePlatNumber']}',
                                  '${item['projectCode']}',
                                  '${item['dmtcNumber']}',
                                  '${item['projectTripRate']}',
                                  '${item['tripExpense']}',
                                  '${item['remainingExpense']}',


                                  12,
                                  FontWeight.w400,
                                  onLongPress: () {
                                    print('object');
                                    print(item);

                                    setState(() {
                                      print('???///////////');
                                      print(selectedItem);
                                      selectedItem = item;
                                      itemIndex = index;
                                    });
                                  },
                                  bgColor: '${selectedItem}' == '${item}'
                                      ? MyColors.yellow
                                      : Colors.white,
                                         IconData: Icons.attachment,
                                    onTab: () {
                                      print('${item['currentFileName']}');
                                      MyNavigation().push(
                                          context,
                                          FileAttachment(
                                            image: '${item['currentFileName']}',
                                          ));
                                    }
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
          ],
        )),
      ),
    );
  }

  dateCont(String text, Function(DateTime) pickedDate) {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
      ),
      margin: EdgeInsets.only(
        left: 5,
      ),
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //child: Text('day-mon-year'),
            child: Text(text),
          ),
          InkWell(
            onTap: () async {
              DateTime? date = await showDatePicker(
                  context: context,
                  fieldHintText: 'day-mon-year',
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025));
              if (date != null) {
                pickedDate(date);

                print(date);
              }
            },
            child: Container(
               margin: EdgeInsets.only(left: 35, right: 5),
              child: Icon(Icons.calendar_today),
            ),
          )
        ],
      ),
    );
  }

  tripListCont(
    String serial,
    String tripN,
    String date,
    String manifesto,
    String platnumber,
    String projectCode,
    String dmtc,
    String triprate,
    String expense,
    String remaining,
    double size,
    FontWeight fontWeight, {
    // String? project,
    Function? onLongPress,
    bgColor,IconData,Function? onTab
  }) {
    return GestureDetector(
      onLongPress: () => onLongPress!(),
      child: Container(
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 25,
            margin: EdgeInsets.only(
              left: 8,
            ),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 100,
            child: Text(
              tripN,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 100,
            child: Text(date,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 110,
           
            child: Text(manifesto,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,
           margin: EdgeInsets.only(left: 5),
            child: Text(platnumber,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,
           
            child: Text(projectCode,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,
           
            child: Text(dmtc,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,
          
            child: Text(triprate,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
           Container(
             width: 100,
           
             child: Text(expense,
                 style: TextStyle(fontSize: size, fontWeight: fontWeight)),
           ),
           Container(
             width: 100,
           
             child: Text(remaining,
                 style: TextStyle(fontSize: size, fontWeight: fontWeight)),
           ),
          GestureDetector(
            onTap: () => onTab!(),
            child: Container(
            width: 90,

              child: Icon(IconData),
            ),
          ),
        ]),
      ),
    );
  }
    textCont(String text, double size, {Color? color}) {
    return Text(
      '$text  ',
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
