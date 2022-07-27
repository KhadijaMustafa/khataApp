import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/new_khata_list.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';

class UpdateKhata extends StatefulWidget {
  final item;
  UpdateKhata({Key? key, this.item}) : super(key: key);

  @override
  State<UpdateKhata> createState() => _UpdateKhataState();
}

class _UpdateKhataState extends State<UpdateKhata> {
  TextEditingController nameEnglish = TextEditingController();
  TextEditingController nameUrdu = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController addressEnglish = TextEditingController();
  TextEditingController addressUrdu = TextEditingController();
  OneContext _context = OneContext.instance;

  var khata;
  bool nameEng = false;
  bool nameUrd = false;
  bool contact = false;
  bool addressE = false;
  bool addressU = false;
  var khatalist;

   getKhataValue() async {
   

    try {
       print('//////////////////////////////////11111111111');
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "KhataCustomer_GetById",
            "value": {"Language": "en-US", "Id": '${widget.item['id']}'}
          }));

      var decode = json.decode(response.body);
      print('Successssssssssssssss');
      print(decode['Value']);
      print(response.body);

      khatalist = json.decode(decode['Value']);
      khata=khatalist["khataNumber"];
      nameEnglish.text = khatalist["nameEng"];
      nameUrdu.text = khatalist["nameUrd"];
      contactNumber.text = khatalist["contactNumber"];
      addressEnglish.text = khatalist["addressEng"];
      addressUrdu.text = khatalist["addressUrd"];



      print('//////////////////////////////////');
      print(khatalist);
     
      print('//////////////////////////////////');
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  getKhataNumber() async {
    try {
      print('/////////////////////////////////???');

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "KhataCustomer_GetNextNumber",
        "value": {
          "Language": "en-US",
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        var dodecode = json.decode(decode['Value']);

        khata = dodecode["khataNumber"];
        print(dodecode);

        print(khata);
        print('/////////////////////////////////');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getKhataNumber();
    getKhataValue();
    super.initState();
  }

  addkhataList() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (nameEnglish.text.isEmpty) {
      setState(() {
        nameEng = true;
      });
    } else if (nameUrdu.text.isEmpty) {
      setState(() {
        nameUrd = true;
      });
    } else if (contactNumber.text.isEmpty) {
      setState(() {
        contact = true;
      });
    } else if (addressEnglish.text.isEmpty) {
      setState(() {
        addressE = true;
      });
    } else if (addressUrdu.text.isEmpty) {
      setState(() {
        addressU = true;
      });
    } else {
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll({
          'type': 'KhataCustomer_Save',
          'Id': '${widget.item['id']}',
          'KhataNumber': khata,
          'NameEng': nameEnglish.text,
          'NameUrd': nameUrdu.text,
          'ContactNumber': contactNumber.text,
          'AddressEng': addressEnglish.text,
          'AddressUrd': addressUrdu.text,
          'UserId': 'f14198a1-1a9a-ec11-8327-74867ad401de',
          'Language': 'en-US'
        });
        _context.showProgressIndicator(
            circularProgressIndicatorColor: MyColors.title);
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
            builder: (context) => NewKhataList(),
          );
          Navigator.pushReplacement(context, route);
          print(decode);
          print('decode');
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
       appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.title,
        title: Text(
          'Update Khata',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(child: Column(
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
              child: Text(khata ?? "",),
            ),
         
            Container(
              child: textFieldCont(
                  'Name (English) ', nameEnglish, nameEng ? Colors.red : Colors.black,
                  onChanged: ((value) {
                setState(() {
                  nameEng = false;
                });
              })),
            ),
            nameEng ? validationCont() : Container(),
             Container(
              child: textFieldCont(
                  'Name (Urdu)', nameUrdu, nameUrd ? Colors.red : Colors.black,
                  onChanged: ((value) {
                setState(() {
                  nameUrd = false;
                });
              })),
            ),
            nameUrd ? validationCont() : Container(),
             Container(
              child: textFieldCont(
                  'Contact ', contactNumber, contact ? Colors.red : Colors.black,
                  onChanged: ((value) {
                setState(() {
                  contact = false;
                });
              }),keyboard: TextInputType.phone),
            ),
            contact ? validationCont() : Container(),
             Container(
              child: textFieldCont(
                  'Address (English) ', addressEnglish, addressE ? Colors.red : Colors.black,
                  onChanged: ((value) {
                setState(() {
                  addressE = false;
                });
              })),
            ),
            addressE ? validationCont() : Container(),
             Container(
              child: textFieldCont(
                  'Address (Urdu) ', addressUrdu, addressU ? Colors.red : Colors.black,
                  onChanged: ((value) {
                setState(() {
                  addressU = false;
                });
              })),
            ),
            addressU ? validationCont() : Container(),

             InkWell(
              onTap: () {
                addkhataList();
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
}
