import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xtreme_fleet/components/textfield_widget.dart';
import 'package:xtreme_fleet/dashboard/employee_list.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';

class AddEmployeeList extends StatefulWidget {
  AddEmployeeList({Key? key}) : super(key: key);

  @override
  State<AddEmployeeList> createState() => _AddEmployeeListState();
}

class _AddEmployeeListState extends State<AddEmployeeList> {
  TextEditingController employeenum = TextEditingController();
  TextEditingController nameeng = TextEditingController();
  TextEditingController nameurd = TextEditingController();
  TextEditingController contactnum = TextEditingController();
  OneContext _context = OneContext.instance;

  var empnum;
  var employeeN;
  var nameEng;
  var nameUrd;
  var positiontype;
  bool number = false;
  bool engN = false;
  bool urdN = false;
  bool contact = false;
  bool position = false;

  List positionList = [];
  List employeeNumList = [];

  getEmployeeNumber() async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/multipart'));
      request.fields.addAll({'type': 'Employee_GetNextNumber'});

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      var decode = json.decode(response.body);
      employeeN = (json.decode(decode))["employeeNumber"];
      print('/////////////////////////////////');

      print(employeeN);
      print('/////////////////////////////////');
      setState(() {
        
      });
    } catch (e) {}
  }

  getPositionDropDown() async {
    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "Position_DropdownList_Get",
            "value": {"Language": "en-US"}
          }));
      print(response.body);
      print(response.statusCode);

      var decode = json.decode(response.body);
      positionList = json.decode(decode['Value']);

      print(positionList);

      setState(() {});

      return positionList;
    } catch (e) {
      print(e);
    }
    ;
  }

  dropdownApiCall() async {
    positionList = await getPositionDropDown();
  }

  @override
  void initState() {
    dropdownApiCall();

    getEmployeeNumber();
    super.initState();
  }

  addEmployee() async {
    FocusManager.instance.primaryFocus?.unfocus();
    print('starttttt..................');
    if (nameeng.text.isEmpty) {
      setState(() {
        engN = true;
      });
    } else if (nameurd.text.isEmpty) {
      setState(() {
        urdN = true;
      });
    } else if (contactnum.text.isEmpty) {
      setState(() {
        contact = true;
      });
    } else {
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll({
          'type': 'Employee_Save',
          'Id': '00000000-0000-0000-0000-000000000000',
          'Language': 'en-US',
          'EmpNumber': employeeN,
          'NameEng': nameeng.text,
          'NameUrd': nameurd.text,
          'Contact': contactnum.text,
          'PositionId': positiontype["value"],
        });

        _context.showProgressIndicator(
            circularProgressIndicatorColor: Color.fromARGB(255, 98, 61, 12));
        http.StreamedResponse streamResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamResponse);
        _context.hideProgressIndicator();
        if (response.statusCode == 200) {
          var decode = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully added.'),
          ));
          Navigator.pop(context);
          var route = MaterialPageRoute(
            builder: (context) => EmployeeList(),
          );
          Navigator.pushReplacement(context, route);
          print(decode);
          print('decode');
        }
      } catch (e) {
        _context.hideProgressIndicator();
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Add Employee',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: width,
              padding: EdgeInsets.only(left: 20, right: 10),
              margin: EdgeInsets.only(left: 20, top: 25, right: 20),
              height: 50,
              decoration: BoxDecoration(
                  color: MyColors.grey,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: MyColors.black)),
              child: Text(employeeN ?? ""),
            ),
            number ? validationCont() : Container(),
            Container(
              child: textFieldCont(
                  'Name (English)', nameeng, engN ? Colors.red : Colors.black,
                  onChanged: ((value) {
                setState(() {
                  engN = false;
                });
              })),
            ),
            engN ? validationCont() : Container(),
            Container(
              child: textFieldCont(
                  'Name (Urdu)', nameurd, urdN ? Colors.red : Colors.black,
                  onChanged: ((value) {
                setState(() {
                  urdN = false;
                });
              })),
            ),
            urdN ? validationCont() : Container(),
            Container(
              child: textFieldCont('Contact Number', contactnum,
                  contact ? Colors.red : Colors.black, onChanged: ((value) {
                setState(() {
                  contact = false;
                });
              }), keyboard: TextInputType.number),
            ),
            contact ? validationCont() : Container(),
            dropdownComp(
                positiontype == null ? "Vehicle Type" : positiontype["text"],
                position ? Colors.red : Colors.black, onchanged: (value) {
              setState(() {
                positiontype = value;
                position = false;
                print(positiontype);
                print('vehicle');
              });
            }, list: positionList, dropdowntext: "text"),
            position ? validationCont() : Container(),
            InkWell(
              onTap: () {
                addEmployee();
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.only(
                  left: 20,
                  top: 40,
                  right: 20,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MyColors.yellow,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: MyColors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  validationCont() {
    return Container(
      margin: EdgeInsets.only(left: 35),
      alignment: Alignment.topLeft,
      height: 15,
      child: Text(
        'This field is required',
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  textFieldCont(String hint, TextEditingController controller, Color,
      {Function(String)? onChanged, TextInputType? keyboard}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Color)),
      child: TextFormField(
        keyboardType: keyboard,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: MyColors.black, fontSize: 14),
            border: InputBorder.none),
        onChanged: (String? value) => onChanged!(value!),
      ),
    );
  }

  dropdownComp(String hinttext, Color bordercolor,
      {Function? onchanged, List? list, String? dropdowntext}) {
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: bordercolor,
            )),
        margin: EdgeInsets.only(left: 20, top: 25, right: 20),
        child: DropdownButtonFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          isExpanded: true,
          decoration: InputDecoration(
              border: InputBorder.none,
              filled: false,
              hintStyle: TextStyle(color: MyColors.black),
              hintText: '$hinttext',
              fillColor: Colors.white),
          onChanged: (value) => onchanged!(value),
          items: list
              ?.map((item) => DropdownMenuItem(
                  value: item, child: Text("${item[dropdowntext]}")))
              .toList(),
        ));
  }
}
