import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/new_khata_list.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:http/http.dart' as http;

class AddKhata extends StatefulWidget {
  AddKhata({Key? key}) : super(key: key);

  @override
  State<AddKhata> createState() => _AddKhataState();
}

class _AddKhataState extends State<AddKhata> {
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

  getKhataNumber()async{

    try {
       

      var headers = {
  'Content-Type': 'application/json'
};
var request = http.Request('POST', Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
request.body = json.encode({
  "type": "KhataCustomer_GetNextNumber",
  "value": {
    "Language": "en-US",
  
  }
});
request.headers.addAll(headers);

    http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);
     
            var decode = json.decode(response.body);
        var dodecode=json.decode(decode['Value']);
        

     khata=dodecode["khataNumber"];
        print(dodecode);

        print(khata);
       
setState(() {
  
});

      

   
         
      
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    getKhataNumber();
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
          'Id': '00000000-0000-0000-0000-000000000000',
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
            circularProgressIndicatorColor: MyColors.dgreen);
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
          'Add Khata',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10,right: 10),
        child: SingleChildScrollView(child: Column(
          children: [
            SizedBox(height: 20,),
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
