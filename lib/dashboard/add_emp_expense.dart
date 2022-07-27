import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/employee_expense.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xtreme_fleet/utilities/pickers.dart';

class AddEmployeeExpense extends StatefulWidget {
  AddEmployeeExpense({Key? key}) : super(key: key);

  @override
  State<AddEmployeeExpense> createState() => _AddEmployeeExpenseState();
}

class _AddEmployeeExpenseState extends State<AddEmployeeExpense> {
  TextEditingController amountController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  OneContext _context = OneContext.instance;
  final _formkey = GlobalKey<FormState>();

  String? imageFile;
  pickImageFomG(ImageSource source) async {
    XFile? file = await Pickers.instance.pickImage(source: source);
    if (file != null) {
      imageFile = file.path;
      setState(() {});
    }
  }

  var expenseType;
  List empNameList = [];
  var name;
  var dateTime;

  DateTime selectedDate = DateTime.now();
  List<String> expenseList = [
    'Salaries',
    'Visa Expense',
    'Insurance Expense',
    'Expense (EDC + QCC + Driving Permit expense)',
    'Other',
  ];

  bool expDropDowm = false;
  bool employeename = false;
  bool amount = false;
  bool setdate = false;
  bool file = false;
  bool remark = false;

  getDropDownValues() async {
    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "Employee_DropdownList_Get",
            "value": {"Language": "en-US"}
          }));
      print(response.body);
      print(response.statusCode);
      print(response.statusCode);
      var decode = json.decode(response.body);
      empNameList = json.decode(decode['Value']);

      setState(() {});

      return empNameList;
    } catch (e) {
      print(e);
    }
    ;
  }

  getListCall() async {
    empNameList = await getDropDownValues();
  }

  @override
  void initState() {
    super.initState();
    getListCall();
    // addExpenses();
  }

  addEmployeeExpenses() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (name == null) {
      setState(() {
        employeename = true;
      });

      print(employeename);
      print('?????????????????????????????????????????????????????');
    } else if (expenseType == null) {
      setState(() {
        expDropDowm = true;
      });
    } else if (amountController.text.isEmpty) {
      setState(() {
        amount = true;
      });
    } else if (CusDateFormat.getDate(selectedDate) == null) {
      setState(() {
        setdate = true;
      });
    }
    //  else if (imageFile == null) {
    //   setState(() {
    //     file = true;
    //   });
    // }
    else if (remarksController.text.isEmpty) {
      setState(() {
        remark = true;
      });
    } else {
      try {
        print('start............');
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll({
          'type': 'EmployeeExpense_Save',
          'Id': '00000000-0000-0000-0000-000000000000',
          'UserId': 'f14198a1-1a9a-ec11-8327-74867ad401de',
          'EmployeeId': name['value'],
          'ExpenseType': expenseType,
          'Amount': amountController.text,
          'ExpenseDate': CusDateFormat.getDate(selectedDate),
          'Remarks': remarksController.text,
          'Language': 'en-US'
        });
        print(name);
        print('expenseType');
        if (imageFile != null) {
          request.files.add(
              await http.MultipartFile.fromPath('Attachment', '$imageFile'));
        }

        _context.showProgressIndicator(
            circularProgressIndicatorColor: Color.fromARGB(255, 98, 61, 12));
        http.StreamedResponse streamResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamResponse);
        _context.hideProgressIndicator();

        print('false');
        // _context.hideProgressIndicator();
        if (response.statusCode == 200) {
          print('statusCode.....................');
          var decode = json.decode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: MyColors.bggreen,
              content: Text('Record succesfully added.')));
          Navigator.pop(context);

          var route = MaterialPageRoute(
            builder: (context) => EmployeeExpense(),
          );
          Navigator.pushReplacement(context, route);

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
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Add Expense',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          key: _formkey,
          child: Column(
            children: [
              //  addExpCont('Employee', '*', ':', Colors.red),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: employeename ? Colors.red : Colors.black,
                    )),
                margin: EdgeInsets.only(left: 20, top: 30, right: 20),
                padding: EdgeInsets.only(left: 20, right: 10),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      filled: false,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: MyColors.black),
                      hintText: name == null ? "Employee" : name['text'],
                      fillColor: Colors.white),
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      name = value;
                      employeename = false;
                    });
                  },
                  items: empNameList
                      .map((item) => DropdownMenuItem(
                          value: item, child: Text("${item['text']}")))
                      .toList(),
                ),
              ),
              employeename ? validationCont() : Container(),
              // addExpCont('Expense Type', '*', ':', Colors.red),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: expDropDowm ? Colors.red : Colors.black,
                    )),
                margin: EdgeInsets.only(left: 20, top: 25, right: 20),
                padding: EdgeInsets.only(left: 20, right: 10),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      hintStyle: TextStyle(color: MyColors.black),
                      hintText:
                          expenseType == null ? 'Expense Type' : expenseType,
                      fillColor: Colors.white),
                  // value: dropDownValue,
                  onChanged: (String? Value) {
                    setState(() {
                      expenseType = Value;
                      expDropDowm = false;
                    });
                  },
                  items: expenseList
                      .map((expenseTitle) => DropdownMenuItem(
                          value: expenseTitle, child: Text("$expenseTitle")))
                      .toList(),
                ),
              ),
              expDropDowm ? validationCont() : Container(),
              // addExpCont('Amount', '*', ':', Colors.red),
              Container(
                margin: EdgeInsets.only(left: 20, top: 25, right: 20),
                padding: EdgeInsets.only(left: 20, right: 10),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: amount ? Colors.red : Colors.black)),
                child: TextFormField(
                  cursorColor: MyColors.black,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: MyColors.black,
                      ),
                      hintText: 'Amount',
                      border: InputBorder.none),
                  onChanged: (String? Value) {
                    setState(() {
                      amount = false;
                    });
                  },
                ),
              ),
              amount ? validationCont() : Container(),
              //addExpCont('Expense Date', '*', ':', Colors.red),
              Container(
                margin: EdgeInsets.only(left: 20, top: 25, right: 20),
                padding: EdgeInsets.only(left: 20, right: 10),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: setdate ? Colors.red : Colors.black)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //child: Text('day-mon-year'),
                      child: Text(
                        selectedDate == null
                            ? 'Expense Date'
                            : '${CusDateFormat.getDate(selectedDate)}',
                        style: TextStyle(color: MyColors.black),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                            context: context,
                            fieldHintText: 'Expense Date',
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2025));
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                            setdate = false;
                          });
                          print(date);
                          print(CusDateFormat.getDate(date));
                        }
                      },
                      child: Container(
                        child: Icon(Icons.calendar_today),
                      ),
                    )
                  ],
                ),
              ),
              setdate ? validationCont() : Container(),
              // addExpCont('Attachment', '*', ':', Colors.white),
              Container(
                margin: EdgeInsets.only(left: 20, top: 25, right: 20),
                padding: EdgeInsets.only(left: 20, right: 10),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  children: [
                    Container(
                      height: 25,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(right: 10, left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(1)),
                      child: InkWell(
                          onTap: () {
                            pickImageFomG(ImageSource.gallery);
                            setState(() {
                              // file = false;
                            });
                          },
                          child: Text('Choose file',
                              style: TextStyle(fontSize: 11))),
                    ),
                    imageFile != null
                        ? Expanded(
                            child: Container(
                              height: 20,
                              child: Text(
                                imageFile!.split('/').last,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          )
                        : Text('No file choosen')
                  ],
                ),
              ),
              // file ? validationCont() : Container(),
              // addExpCont('Remarks', '*', ':', Colors.red),
              Container(
                margin: EdgeInsets.only(left: 20, top: 30, right: 20),
                padding: EdgeInsets.only(left: 20, right: 10, top: 10),
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: remark ? Colors.red : Colors.black)),
                child: TextFormField(
                  cursorColor: MyColors.black,

                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: remarksController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Remarks.................',
                    border: InputBorder.none,
                  ),
                  onChanged: (String? Value) {
                    setState(() {
                      remark = false;
                    });
                  },
                ),
              ),
              remark ? validationCont() : Container(),
              InkWell(
                onTap: () {
                  addEmployeeExpenses();
                },
                child: Container(
                  height: 50,
                  margin:
                      EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 20),
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
          ),
        ),
      ),
    );
  }

  cDropdown(List<String> list, String selected, Function(String) onChanged) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          hintText: 'Select Type',
          fillColor: Colors.white),
      value: selected,
      onChanged: (String? value) => onChanged(value!),
      items: list
          .map((expenseTitle) => DropdownMenuItem(
              value: expenseTitle, child: Text("$expenseTitle")))
          .toList(),
    );
  }

  addExpCont(String title, String asterisk, String colon, Color color) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20, top: 15),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: title, style: TextStyle(color: Colors.black, fontSize: 18)),
        TextSpan(text: asterisk, style: TextStyle(color: color, fontSize: 18)),
        TextSpan(
            text: colon, style: TextStyle(color: Colors.black, fontSize: 18)),
      ])),
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
}
