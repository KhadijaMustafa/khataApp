import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xtreme_fleet/dashboard/add_veh_expense.dart';
import 'package:xtreme_fleet/dashboard/edit_veh_expense.dart';
import 'package:xtreme_fleet/dashboard/file_attachment.dart';
import 'package:xtreme_fleet/resources/app_data.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:xtreme_fleet/utilities/notification_util.dart';

import 'package:xtreme_fleet/utilities/pickers.dart';

import 'dart:io';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VehicleExpense extends StatefulWidget {
  final String? expenseType;

  VehicleExpense({
    Key? key,
    this.expenseType,
  }) : super(key: key);

  @override
  State<VehicleExpense> createState() => _VehicleExpenseState();
}

class _VehicleExpenseState extends State<VehicleExpense> {
  int itemIndex = 0;
  bool isDownloading = false;
  double totalAmount = 0.0;
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
      print(filePathAndName);
      await Directory(parent).create(recursive: true);
      File file = File(filePathAndName);
      file.writeAsBytesSync(response.bodyBytes);
      print(file.path);
      print('file path');

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

  String? imageFile;
  pickImageFomG(ImageSource source) async {
    XFile? file = await Pickers.instance.pickImage(source: source);
    if (file != null) {
      imageFile = file.path;
      setState(() {});
    }
  }

  String? expenseDropDowm;
  List plotList = [];
  var dropDownValue;

  DateTime selectedDate = DateTime.now();
  List<String> expenseDList = [
    'Select Type',
    'Plat Number',
    'Diesel Expense',
    'Vehicle Insurrence',
    'Other',
  ];
  List addVeh = [];
  bool loading = true;
  List expenseList = [];
  List filterList = [];
  bool isSearching = false;
  var selectedItem;

  bool plotNumber = false;
  List notFound = [];

  TextEditingController searchController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  OneContext _context = OneContext.instance;
  final _formkey = GlobalKey<FormState>();

  getDropDownValues() async {
    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "Vehicle_DropdownList_Get",
            "value": {"Language": "en-US"}
          }));
      print(response.body);
      print(response.statusCode);
      var decode = json.decode(response.body);
      plotList = json.decode(decode['Value']);
      setState(() {});
      print('???????????????????????????????????????');
    } catch (e) {}
  }

  getListCall() {
    getDropDownValues();
  }

  @override
  void initState() {
    super.initState();
    getListCall();
    expCallApi();
    // addExpenses();
  }

  editVehExpense() async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/multipart'));
      request.fields.addAll({
        'type': 'VehicleExpense_Save',
        'Id': '00000000-0000-0000-0000-000000000000',
        'UserId': 'f14198a1-1a9a-ec11-8327-74867ad401de',
        'VehicleId': dropDownValue['value'],
        'ExpenseType': expenseDropDowm!,
        'Amount': amountController.text,
        'ExpenseDate': CusDateFormat.getDate(selectedDate),
        'Remarks': remarksController.text,
        'Language': 'en-US'
      });
      request.files
          .add(await http.MultipartFile.fromPath('Attachment', '$imageFile'));
      _context.showProgressIndicator();
      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);
      _context.hideProgressIndicator();

      print('false');
      // _context.hideProgressIndicator();
      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully added.')));

        print('trueeeeeeeeeeeeeeeeeeeeeeee');
        //var doDecode = json.decode(decode);

        print(decode);
        return decode;
      } else {
        print('falseeeeeeeeeeeeeeeeeeee');
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }
  //update

  getVehExpense() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "VehicleExpense_GetAll",
        "value": {"Language": "en-US"}
      });
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('Successssssssssssssss');
        print(decode['Value']);
        print(decode[response.body]);

        return json.decode(decode['Value']);
        //json.decode(decode['Value']);

      }
    } catch (e) {
      print(e);
    }
  }

  expCallApi() async {
    expenseList = await getVehExpense();
    loading = false;
    calculateAmount();
    setState(() {});
  } //add

  deleteItem() async {
    print('ppppppppppppppppppppppppp');
    print({
      "type": "VehicleExpense_Delete",
      "value": {
        "Id": "${selectedItem['id']}",
        "UserId": AppData.instance.userData['id'],
        "Language": "en-US"
      }
    });

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "VehicleExpense_Delete",
        "value": {
          "Id": "${selectedItem['id']}",
          "UserId": '${AppData.instance.userData['id']}',
          "Language": "en-US"
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully deleted.')));
        expenseList.removeAt(itemIndex);

        setState(() {
          selectedItem = null;
        });
        calculateAmount();
        print('Successssssssssssssss');
        print(decode);
      }
    } catch (e) {
      print(e);
    }
  } //delete

  calculateAmount() {
    totalAmount = 0.0;
    expenseList.forEach((element) {
      totalAmount = totalAmount + element['amount'];
      print(totalAmount);
      print('totalAmount');
      setState(() {});
    });
  } //tatal

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
      keys.addAll(
          ['PlatNumber', 'ExpenseType', 'ExpenseDate', 'Amount', 'Remarks']);
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
      // var exits = await getExternalStorageDirectory();
      // (await getApplicationDocumentsDirectory()).path;
      // print(exits);
      var documentDirectory = await getExternalStorageDirectory();
      var parent = documentDirectory!.path;

      String fileName = '$parent/excel.xlsx';
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
      
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      showMessage('Some error occured please try again', MyColors.bgred);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
          //getVehExpense();
          MyNavigation().push(context, AddVehicleExpense());
        },
        child: Icon(Icons.add),
        backgroundColor: MyColors.yellow,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: selectedItem == null
            ? Text(
                'Vehicle Expense List',
                style: TextStyle(color: Colors.white),
              )
            : Container(),
        actions: [
          selectedItem == null
              ? InkWell(
                  onTap: () {
                    if (!isDownloading) {
                      exportxlsx(expenseList);
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
                                    color: Colors.white,
                                    strokeWidth: 1.0,
                                  )
                                : Container(),
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                             InkWell(
                                        onTap: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: MyColors.bgred
                                        ),
                                      margin: EdgeInsets.only(left: 5,right: 5),
                                 
                                          child: Text('No',
                                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)))),

                                            TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context, deleteItem());
                                          setState(() => selectedItem = null);
                                        },
                                        child: Container(
                                     padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: MyColors.bggreen
                                        ),
                                
                                      margin: EdgeInsets.only(left: 5,right: 5),
                                         

                                          child: Text(
                                            'Yes',
                                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                          ),
                                        )),

                                        ],
                                      ),
                                    )
                                  ],
                                );
                              });
                          // AlertDialog();
                          // deleteItem();
                          // setState(() => id = null);
                        },
                        child: actionIcon(
                          Icons.delete,
                        )),
                    // GestureDetector(
                    //     onTap: () {}, child: actionIcon(Icons.attachment)),
                    GestureDetector(
                        onTap: () {
                          MyNavigation().push(
                              context,
                              EditVehicleExpense(
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
                backgroundColor: MyColors.yellow,
              ),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      //margin: EdgeInsets.all(10),
                      // height: 50,
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.only(
                            left: 20, top: 4, bottom: 4, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: MyColors.grey)),
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: TextFormField(
                          cursorColor: MyColors.black,
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

                                          List filtered = expenseList
                                              .where((item) =>
                                                  '${item['platNumber']}'
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
                        width: width+300,
                        child: Column(
                        children: [
                           Container(
                            //padding: EdgeInsets.all(5),
                            //margin: EdgeInsets.all(5),
                            color: Color.fromARGB(255, 234, 227, 227),
                            child: vehExpCont('#','Plate #', 'Expense Type', 'Expense Date',
                                'Amount', 'Remarks', 15, FontWeight.bold),
                          ),
                            Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              // scrollDirection: Axis.vertical,
                              itemCount: isSearching
                                  ? filterList.length
                                  : expenseList.length,
                              itemBuilder: (BuildContext context, int index) {
                                int indexx=index+1;
                                var item = isSearching
                                    ? filterList[index]
                                    : expenseList[index];
                                // return Container();
                                return vehExpCont('$indexx',
                                    '${item['platNumber']} ',
                                    '${item['expenseType']}',
                                    '${item['expenseDate']}',
                                    '${item['amount']}',
                                    '${item['remarks']}',
                                    12,
                                    FontWeight.normal,
                                    onLongPress: () {
                                      print('object');
                                      CupertinoColors.darkBackgroundGray;
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
                          ),

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

  vehExpCont(String serial,String platenmbr, String expType, String expiryDate, String amount,
      String remarks, double size, FontWeight fontWeight,
      {String? project,
      Function? onLongPress,
      bgColor,
      IconData,
      Function? onTab}) {
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
            margin: EdgeInsets.only(left: 8,right: 8),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 100,

            child: Text(
              platenmbr,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 120,

            child: Text(expType,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,

            margin: EdgeInsets.only(left: 5),
            child: Text(expiryDate,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 80,

            alignment: Alignment.bottomRight,
          
            child: Text(amount,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 120,

            alignment: Alignment.bottomRight,
           
            child: Text(remarks,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
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
// android {                                                                                                  │
// │   defaultConfig {                                                                                          │
// │     minSdkVersion 21                                                                                       │
// │   }                                                                                                        │
// │ } 