import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/khata_transaction_list.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/pickers.dart';

class UpdateTransaction extends StatefulWidget {
  final item;
  UpdateTransaction({Key? key, this.item}) : super(key: key);

  @override
  State<UpdateTransaction> createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  OneContext _context = OneContext.instance;
  TextEditingController amountController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  var customer;
  var transaction;
  bool amount = false;
  bool remark = false;
  bool cust = false;
  bool trasac = false;
  bool setdate = false;

  List customerList = [];

  List<String> transactionList = [
    'Debit (+)',
    'Credit (-)',
  ];

  String? imageFile;
  pickImageFomG(ImageSource source) async {
    XFile? file = await Pickers.instance.pickImage(source: source);
    if (file != null) {
      imageFile = file.path;
      setState(() {});
    }
  }

  getDropDownValues() async {
    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "KhataCustomer_DropdownList_Get",
            "value": {"Language": "en-US"}
          }));
      print(response.body);
      print(response.statusCode);

      var decode = json.decode(response.body);
      customerList = json.decode(decode['Value']);

      print(customerList);

      setState(() {});

      return customerList;
    } catch (e) {
      print(e);
    }
    ;
  }

  getListCall() async {
    customerList = await getDropDownValues();
  }

  @override
  void initState() {
    
    getListCall();

    
    customer = {
      'value': widget.item['khataCustomerId'],
      'text': widget.item['khataCustomerName']
    };
    transaction = widget.item['transactionType'];

     amountController.text = widget.item['amountPaid'].toString().split('.').first;
       selectedDate = DateTime.parse(widget.item!['paidDate']);
   
    if (imageFile != null) {
      imageFile = widget.item['currentFileName'];
    }

 
     remarksController.text = widget.item['reason'];
     setState(() {
       
     });
     super.initState();
  }

  updateTransaction() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (customer == null) {
      setState(() {
        cust = true;
      });

      print(customer);
      print('?????????????????????????????????????????????????????');
    } else if (transaction == null) {
      setState(() {
        trasac = true;
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
       'type': 'Transaction_Save',
  'Id': '${widget.item['id']}',
  'TransactionType': transaction,
  'AmountPaid': amountController.text,
  'PaidDate': CusDateFormat.getDate(selectedDate),
  'Reason': remarksController.text,
  'KhataCustomerId': customer['value'],
  'UserId': 'f14198a1-1a9a-ec11-8327-74867ad401de',
  'Language': 'en-US'
        });
       
      
        if (imageFile != null) {
          request.files.add(
              await http.MultipartFile.fromPath('Attachment', '$imageFile'));
        }

        _context.showProgressIndicator(
            circularProgressIndicatorColor: MyColors.dgreen);
        http.StreamedResponse streamResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamResponse);
        _context.hideProgressIndicator();

        print('false');
       
        if (response.statusCode == 200) {
          print('statusCode.....................');
          var decode = json.decode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: MyColors.bggreen,
              content: Text('Record succesfully updated.')));
          Navigator.pop(context);

          var route = MaterialPageRoute(
            builder: (context) => KhataTransactionList(),
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.title,
        title: Text(
          'Update Transaction',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            dropdownComp(customer == null ? "Customer Name" : customer["text"],
                cust ? Colors.red : Colors.black, onchanged: (value) {
              setState(() {
                customer = value;
                cust = false;
              });
            }, list: customerList, dropdowntext: "text"),
            cust ? validationCont() : Container(),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: trasac ? Colors.red : Colors.black,
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
                        transaction == null ? 'Expense Type' : transaction,
                    fillColor: Colors.white),
                // value: dropDownValue,
                onChanged: (String? Value) {
                  setState(() {
                    transaction = Value;
                    trasac = false;
                  });
                },
                items: transactionList
                    .map((expenseTitle) => DropdownMenuItem(
                        value: expenseTitle, child: Text("$expenseTitle")))
                    .toList(),
              ),
            ),
            trasac ? validationCont() : Container(),
            textFieldCont(
                'Amount', amountController, amount ? Colors.red : Colors.black,
                onChanged: (value) {
              setState(() {
                amount = false;
              });
            }, keyboard: TextInputType.number,collapse: false),
            amount ? validationCont() : Container(),
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
                      CusDateFormat.getDate(selectedDate) == null
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
            textFieldCont('Remarks...', remarksController,
                remark ? Colors.red : Colors.black, onChanged: (value) {
              setState(() {
                remark = false;
              });
            },keyboard: TextInputType.multiline,maxline: null,collapse: true),
            remark ? validationCont() : Container(),
            InkWell(
              onTap: () {
                updateTransaction();
              },
              child: Container(
                height: 50,
                margin:
                    EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MyColors.title,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: MyColors.dgreen,
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
      {Function(String)? onChanged, TextInputType? keyboard,int? maxline,bool? collapse}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Color)),
      child: TextFormField(
        maxLines: maxline,
        keyboardType: keyboard,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          isCollapsed: collapse!,
            hintText: hint,
            hintStyle: TextStyle(color: MyColors.black, fontSize: 14),
            border: InputBorder.none),
        onChanged: (value) => onChanged!(value),
      ),
    );
  }
}
