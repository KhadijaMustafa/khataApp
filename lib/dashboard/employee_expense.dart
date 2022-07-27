import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xtreme_fleet/dashboard/add_emp_expense.dart';
import 'package:xtreme_fleet/dashboard/file_attachment.dart';
import 'package:xtreme_fleet/dashboard/update_emp_expense.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/resources/app_data.dart';
import 'package:xtreme_fleet/utilities/notification_util.dart';

class EmployeeExpense extends StatefulWidget {
  EmployeeExpense({Key? key}) : super(key: key);

  @override
  State<EmployeeExpense> createState() => _EmployeeExpenseState();
}

class _EmployeeExpenseState extends State<EmployeeExpense> {
  TextEditingController searchController = TextEditingController();

  bool isDownloading = false;
  double totalAmount = 0.0;
  List filterList = [];
  bool isSearching = false;
  String? image;
  

  imageDownload(String url) async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    if (!status.isGranted) {
      return;
    }
    setState(() {
      isDownloading = true;
    });

    String wholeUrl = 'https://fleet.xtremessoft.com/UploadFile/' + url;
    try {
      http.Response response = await http.get(Uri.parse(wholeUrl));
      // var documentDirectory = await getApplicationDocumentsDirectory();
      var documentDirectory = await getExternalStorageDirectory();
      var parent = documentDirectory!.path;
      var filePathAndName = "$parent/$url";
      //print(filePathAndName);
      await Directory(parent).create(recursive: true);
      File file = File(filePathAndName);
      file.writeAsBytesSync(response.bodyBytes);
      print(file.path);
      print('sssssssssssssssddddddddddddddddd');
      setState(() {
        isDownloading = false;
      });
      showMessage('Download Successful', MyColors.bggreen);
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      showMessage('Some error occured please try again', MyColors.bgred);
    }
    // return Media(file, filePathAndName);
  } ////////////

  showMessage(String title, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(title)));
  }

  List employeeList = [];
  var selectedItem;
  bool loading = true;
  int itemIndex = 0;
  getEmployeeExpense() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "EmployeeExpense_GetAll",
        "value": {"Language": "en-US"}
      });
      request.headers.addAll(headers);
      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        print('stateCode..............');
        var decode = json.decode(response.body);
        var dodecode = json.decode(decode['Value']);
        print(response.body);
        print(dodecode);
        return dodecode;
      }
    } catch (e) {}
  }

  employeeExpenseCall() async {
    employeeList = await getEmployeeExpense();
    loading = false;
    calculateAmount();
    setState(() {});
  }

  @override
  void initState() {
    employeeExpenseCall();

    super.initState();
  } //emploeeListt

  deleteEmployeeData() async {
    print('start............');
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "EmployeeExpense_Delete",
        "value": {
          "Id": "${selectedItem['id']}",
          "UserId": "${AppData.instance.userData['id']}",
          "Language": "en-US"
        }
      });
      print('${AppData.instance.userData['id']}');
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      print('???????????????????????');
      if (response.statusCode == 200) {
        print(response.statusCode);
        print('statusCode');
        var decode = json.decode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully deleted.')));
        employeeList.removeAt(itemIndex);

        setState(() {
          selectedItem = null;
        });
        calculateAmount();
        print(decode);
      }
    } catch (e) {
      print(e);
    }
  } //delete

  calculateAmount() {
    totalAmount = 0.0;
    employeeList.forEach((element) {
      totalAmount = totalAmount + element['amount'];
      print(totalAmount);
      print('totalAmount');
      setState(() {});
    });
  } //total

  void exportxlsx(List li) async {
    setState(() {
      isDownloading = true;
    });
    try {
      var excel = Excel.createExcel();
      String path = Directory('/storage/emulated/0/Download').path;
      List<String> keys = [];
      var sheet = excel['Sheet1'];
      // li.first.forEach((key, value) {
      //   keys.add(key);
      // });
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

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 40,
          color: MyColors.yellow,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  'Tatal : ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text('$totalAmount '),
              ),
              //calculateAmount()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyNavigation().push(context, AddEmployeeExpense());
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: MyColors.yellow,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: selectedItem == null
            ? Text(
                'Employee Expense List',
                style: TextStyle(color: Colors.white),
              )
            : Container(),
        actions: [
          selectedItem == null
              ? InkWell(
                  onTap: () {
                    if (!isDownloading) {
                      exportxlsx(employeeList);
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
                )
              : Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //title: Text('data'),
                                  content: Text(
                                    'Do you want to delete this record?',
                                    style: TextStyle(
                                        color: MyColors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: MyColors.bgred),
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Text('No',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .bold)))),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context,
                                                    deleteEmployeeData());
                                                setState(
                                                    () => selectedItem = null);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: MyColors.bggreen),
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        child: actionIcon(Icons.delete)),
                    GestureDetector(
                        onTap: () {
                          MyNavigation().push(
                              context,
                              UpdateEmployeeExpense(
                                item: selectedItem,
                              ));
                        },
                        child: actionIcon(FontAwesomeIcons.penToSquare)),
                    GestureDetector(
                        onTap: () => setState(() => selectedItem = null),
                        child: actionIcon(Icons.close)),
                  ],
                )
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: MyColors.yellow,
              ),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      // height: 50,
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.only(
                            left: 20, top: 4, bottom: 4, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: MyColors.grey)),
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: searchController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search here .........',
                              suffixIcon: GestureDetector(
                                  onTap: isSearching
                                      ? () {
                                          searchController.clear();
                                          setState(() {
                                            isSearching = false;
                                          });
                                        }
                                      : () {
                                          setState(() {
                                            isSearching = true;
                                            filterList.clear();
                                          });
                                          List filtered = employeeList
                                              .where((item) =>
                                                  '${item['name']}'
                                                      .toLowerCase()
                                                      .contains(searchController
                                                          .text
                                                          .toLowerCase()) ||
                                                  '${item['expenseDate']}'
                                                      .toLowerCase()
                                                      .contains(searchController
                                                          .text
                                                          .toLowerCase()) ||
                                                  '${item['expenseType']}'
                                                      .toLowerCase()
                                                      .contains(searchController
                                                          .text
                                                          .toLowerCase()))
                                              .toList();
                                          print(
                                              '{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{');
                                          print(filtered);
                                          setState(() {
                                            filterList = filtered;
                                          });
                                        },
                                  child: Icon(
                                    isSearching ? Icons.close : Icons.search,
                                    size: 30,
                                    color: MyColors.yellow,
                                  ))),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: width+320,
                          child: Column(
                        children: [
                          Container(
                         
                            // margin: EdgeInsets.all(10),
                            color: Color.fromARGB(255, 234, 227, 227),
                            child: empExpCont('#', 'Name', 'Expense Type', 'Expense Date',
                                'Amount', 'Remarks', 15, FontWeight.bold),
                          ),
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: isSearching
                                  ? filterList.length
                                  : employeeList.length,
                              itemBuilder: (BuildContext context, int index) {
                                int indexx = index + 1;
                                var item = isSearching
                                    ? filterList[index]
                                    : employeeList[index];
                                return empExpCont(
                                    '$indexx',
                                    '${item['name']}',
                                    '${item['expenseType']}',
                                    '${item['expenseDate']}',
                                    '${item['amount']}',
                                    '${item['remarks']}',
                                    //'${item['currentFileName']}',

                                    12,
                                    FontWeight.normal,
                                    onLongPress: () {
                                      print('object');

                                      setState(() {
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
                                    });
                              },
                            ),
                          )
                        ],
                      )),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  actionIcon(IconData) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: Icon(
        IconData,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  empExpCont(String serial, String title, String document, String expiryDate,
      String amount, String remarks, double size, FontWeight fontWeight,
      {String? project,
      Function? onLongPress,
      bgColor,
      IconData,
      Function? onTab}) {
    return GestureDetector(
      onLongPress: () => onLongPress!(),
      child: Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            width: 25,
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 110,
            child: Text(
              title,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          SizedBox(width: 5,),

          Container(
            width: 120,
            child: Text(document,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          SizedBox(width: 5,),
          
          Container(
            width: 120,

            //margin: EdgeInsets.only(left: 10),
            child: Text(expiryDate,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          SizedBox(width: 5,),

          Container(
            width: 100,
            child: Text(amount,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          SizedBox(width: 5,),

          Container(
            width: 120,
            child: Text(remarks,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          //
          GestureDetector(
            onTap: () => onTab!(),
            child: Container(
              width: 100,
              child: Icon(IconData),
            ),
          ),
        ]),
      ),
    );
  }
}
