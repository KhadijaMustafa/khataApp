import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/customer_list.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
class UpdateCustomer extends StatefulWidget {
  final item;
  UpdateCustomer({Key? key,this.item}) : super(key: key);

  @override
  State<UpdateCustomer> createState() => _UpdateCustomerState();
}

class _UpdateCustomerState extends State<UpdateCustomer> {
     OneContext _context = OneContext.instance;

  TextEditingController contactNumber = TextEditingController();
  TextEditingController nameEngController = TextEditingController();
  TextEditingController nameUrduController = TextEditingController();
  TextEditingController addressUrdController = TextEditingController();
  TextEditingController addressEngController = TextEditingController();
  var customerName;
   bool contact = false;
  bool name = false;
  bool nameurd = false;
  bool addressUr = false;
  bool addressEng = false;
  bool customer = false;
  List customerTypeDropdown=[];

   getDropDownValues() async {
    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "Setup_CustomerType_DropdownList_Get",
            "value": {"Language": "en-US"}
          }));
      print(response.body);
      print(response.statusCode);

      var decode = json.decode(response.body);
      customerTypeDropdown = json.decode(decode['Value']);

      print(customerTypeDropdown);

      setState(() {});

      return customerTypeDropdown;
    } catch (e) {
      print(e);
    }
    ;
  }

  getListCall() async {
    customerTypeDropdown = await getDropDownValues();

  }

 addCustomerType() async {
    FocusManager.instance.primaryFocus?.unfocus();
    print('starttttt..................');
   if (nameEngController.text.isEmpty) {
      setState(() {
        name = true;
      });
    } else if (nameUrduController.text.isEmpty) {
      setState(() {
        nameurd = true;
      });
    } 
    else if (contactNumber.text.isEmpty) {
      setState(() {
        contact = true;
      });
    }
    else if (addressEngController.text.isEmpty) {
      setState(() {
        addressEng = true;
      });
    }
    else if (addressUrdController.text.isEmpty) {
      setState(() {
        addressUr = true;
      });
    }
    else if (customerName == null) {
      setState(() {
        customer = true;
      });
    }  else {
      Map<String, String> body={
           'type': 'Customer_Save',
  'Id': '${widget.item['id']}',
  'NameEng': nameEngController.text,
  'NameUrd': nameUrduController.text,
  'Contact': contactNumber.text,
  'AddressEng': addressEngController.text,
  'AddressUrd': addressUrdController.text,
  'SetupCustomerTypeId': customerName['value'],
  'Language': 'en-US'
        };
        print(body);
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll(body);

        _context.showProgressIndicator(
            circularProgressIndicatorColor: Color.fromARGB(255, 98, 61, 12));
        http.StreamedResponse streamResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamResponse);
        _context.hideProgressIndicator();
        print('object');
        if (response.statusCode == 200) {
        print('object');

          var decode = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully added.'),
          ));
          Navigator.pop(context);
          var route = MaterialPageRoute(
            builder: (context) => CustomerList(),
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
  void initState() {
    getDropDownValues();
    nameEngController.text=widget.item['nameEng'];
    nameUrduController.text=widget.item['nameUrd'];
    contactNumber.text=widget.item['contact'];
    addressEngController.text=widget.item['addressEng'];
    addressUrdController.text=widget.item['addressUrd'];
    customerName={'value':widget.item['setupCustomerTypeId'],'text':widget.item['customerType']};

    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
     
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Add Customer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(child: Column(
          children: [
             textFieldCont(
              'Name (English)',
              nameEngController,
              name ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  name = false;
                });
              },
            ),
            name ? validationCont() : Container(),
            
              textFieldCont(
              'Name (Urdu)',
              nameUrduController,
              nameurd ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  nameurd = false;
                });
              },
            ),
            nameurd ? validationCont() : Container(),
             textFieldCont(
              'Contact Number',
              contactNumber,
              contact ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  contact = false;
                });
              },keyboard: TextInputType.number
            ),
            contact ? validationCont() : Container(),
             textFieldCont(
              'Address (English)',
              addressEngController,
              addressEng ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  addressEng = false;
                });
              },
            ),
            addressEng ? validationCont() : Container(),
             textFieldCont(
              'Address (Urdu)',
              addressUrdController,
              addressUr ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  addressUr = false;
                });
              },
            ),
            addressUr ? validationCont() : Container(),
            dropdownComp(
                customerName == null ? "Customer Type" : customerName["text"],
                customer ? Colors.red : Colors.black, onchanged: (value) {
              setState(() {
                customerName = value;
                customer = false;
              });
            }, list: customerTypeDropdown, dropdowntext: "text"),
            customer ? validationCont() : Container(),
               InkWell(
                onTap: () {
                  addCustomerType();
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
        onChanged: (value) => onChanged!(value),
      ),
    );
  }
  }
