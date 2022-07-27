import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/vehicle_supplier.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';

class UpdateVehicleSupplier extends StatefulWidget {
  final item;
  UpdateVehicleSupplier({Key? key, this.item}) : super(key: key);

  @override
  State<UpdateVehicleSupplier> createState() => _UpdateVehicleSupplierState();
}

class _UpdateVehicleSupplierState extends State<UpdateVehicleSupplier> {
  TextEditingController username = TextEditingController();
  TextEditingController usernameurdu = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController addressurdu = TextEditingController();

  TextEditingController contact = TextEditingController();
  TextEditingController contactperson = TextEditingController();
  TextEditingController contactpersonurdu = TextEditingController();

  OneContext _context = OneContext.instance;
  bool name = false;
  bool nameurdu = false;

  bool addressfield = false;
  bool addressfieldurdu = false;

  bool contactnumber = false;
  bool contactper = false;
  bool contactperurdu = false;

  bool _addkhata = false;
  bool get addkhata => _addkhata;
  checkbox(bool value) {
    print(value);
    _addkhata = value;
    setState(() {});
  }

  addVehSupplier() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (username.text.isEmpty) {
      setState(() {
        name = true;
      });
    } else if (usernameurdu.text.isEmpty) {
      setState(() {
        nameurdu = true;
      });
    } else if (contact.text.isEmpty) {
      setState(() {
        contactnumber = true;
      });
    } else if (contactperson.text.isEmpty) {
      setState(() {
        contactper = true;
      });
    } else if (contactpersonurdu.text.isEmpty) {
      setState(() {
        contactperurdu = true;
      });
    } else if (address.text.isEmpty) {
      setState(() {
        addressfield = true;
      });
    } else if (addressurdu.text.isEmpty) {
      setState(() {
        addressfieldurdu = true;
      });
    } else {
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll({
          'type': 'VehicleSupplier_Save',
          'Id': '${widget.item['id']}',
          'UserId': '00000000-0000-0000-0000-000000000000',
          'NameEng': username.text,
          'NameUrd': usernameurdu.text,
          'ContactNumber': contact.text,
          'ContactPersonEng': contactperson.text,
          'ContactPersonUrd': contactpersonurdu.text,
          'AddressEng': address.text,
          'AddressUrd': addressurdu.text,
          'AddToKhata': _addkhata ? 'Yes' : 'No',
          'Language': 'en-US'
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
              content: Text('Record succesfully updated.')));
          Navigator.pop(context);
          var route = MaterialPageRoute(
            builder: (context) => VehicleSupplier(),
          );
          Navigator.pushReplacement(context, route);
          print(decode);
          print('decode');
        }
      } catch (e) {}
    }
  }

  @override
  void initState() {
    print(widget.item);
    username.text = widget.item!['name'];
    usernameurdu.text = widget.item!['nameUrd'];

    contact.text = widget.item!['contactNumber'];
    contactperson.text = widget.item!['contactPerson'];
    contactpersonurdu.text = widget.item!['contactPersonUrd'];

    address.text = widget.item!['addressEng'];
    addressurdu.text = widget.item!['addressUrd'];
    _addkhata = widget.item!['addToKhata'] == 'Yes' ? true : false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Update Vehicle Supplier',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //addExpCont('Name', '*', ':', Colors.red),
              Container(
                child: textFieldCont('Name (English)', username,
                    name ? Colors.red : Colors.black, onChanged: ((value) {
                  setState(() {
                    name = false;
                  });
                })),
              ),
              name ? validationCont() : Container(),
              Container(
                child: textFieldCont('Name (Urdu)', usernameurdu,
                    nameurdu ? Colors.red : Colors.black, onChanged: ((value) {
                  setState(() {
                    nameurdu = false;
                  });
                })),
              ),
              nameurdu ? validationCont() : Container(),

              // addExpCont('Contact Number', '*', ':', Colors.red),
              Container(
                child: textFieldCont('Contact Number', contact,
                    contactnumber ? Colors.red : Colors.black,
                    onChanged: ((value) {
                  setState(() {
                    contactnumber = false;
                  });
                }), keyboard: TextInputType.phone),
              ),
              contactnumber ? validationCont() : Container(),
              //addExpCont('Contact Person', '*', ':', Colors.red),
              Container(
                child: textFieldCont('Contact Person (English)', contactperson,
                    contactper ? Colors.red : Colors.black,
                    onChanged: ((value) {
                  setState(() {
                    contactper = false;
                  });
                })),
              ),
              contactper ? validationCont() : Container(),
              Container(
                child: textFieldCont('Contact Person (Urdu)', contactpersonurdu,
                    contactperurdu ? Colors.red : Colors.black,
                    onChanged: ((value) {
                  setState(() {
                    contactperurdu = false;
                  });
                })),
              ),
              contactperurdu ? validationCont() : Container(),
              // addExpCont('Address', '*', ':', Colors.red),
              Container(
                child: textFieldCont('Address (English)', address,
                    addressfield ? Colors.red : Colors.black,
                    onChanged: ((value) {
                  setState(() {
                    addressfield = false;
                  });
                })),
              ),
              addressfield ? validationCont() : Container(),
              // addExpCont('Address', '*', ':', Colors.red),
              Container(
                child: textFieldCont('Address (Urdu)', addressurdu,
                    addressfieldurdu ? Colors.red : Colors.black,
                    onChanged: ((value) {
                  setState(() {
                    addressfieldurdu = false;
                  });
                })),
              ),
              addressfieldurdu ? validationCont() : Container(),
              Container(
                margin: EdgeInsets.only(left: 20, top: 25),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: Text(
                        'Add to Khata',
                        style: TextStyle(color: MyColors.black),
                      ),
                    ),
                    checkboxCont(addkhata, onTab: (value) => checkbox(value)),
                  ],
                ),
              ),

              InkWell(
                onTap: () {
                  addVehSupplier();
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

  checkboxCont(bool ischecked, {Function(bool)? onTab}) {
    return GestureDetector(
      onTap: () => onTab!(!ischecked),
      child: Stack(alignment: Alignment.center, children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: MyColors.black)),
          height: 20,
          width: 18,
        ),
        Container(
          height: 25,
          width: 25,
        ),
        if (ischecked)
          Icon(
            Icons.check,
            color: MyColors.yellow,
          )
      ]),
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
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      padding: EdgeInsets.only(left: 20, right: 10),
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
        // onChanged: (String? Value) {
        //   onChanged;
        // },
      ),
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
}
