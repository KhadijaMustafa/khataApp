import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/setup_vehicle_type.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:http/http.dart' as http;
class AddVehicleType extends StatefulWidget {
  AddVehicleType({Key? key}) : super(key: key);

  @override
  State<AddVehicleType> createState() => _AddVehicleTypeState();
}

class _AddVehicleTypeState extends State<AddVehicleType> {
  TextEditingController englishnameController=TextEditingController();
  TextEditingController urdunameController=TextEditingController();
     OneContext _context = OneContext.instance;


  bool engname=false;
  bool urdname=false;
   addVehicleType() async {
    FocusManager.instance.primaryFocus?.unfocus();
    print('starttttt..................');
    if (englishnameController.text.isEmpty) {
      setState(() {
        engname = true;
      });
    } else if(urdunameController.text.isEmpty){
      setState(() {
        urdname=true;
      });
    } else {
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll({
          'type': 'Setup_VehicleType_Save',
          'Id': '00000000-0000-0000-0000-000000000000',
          'nameEng': englishnameController.text,
          'nameUrd': urdunameController.text,
          
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
            content: Text('Record succesfully added.'),
          ));
          Navigator.pop(context);
          var route = MaterialPageRoute(
            builder: (context) => SetUpVehicleType(),
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
    return Scaffold(
          appBar: AppBar(
       
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Add Vehicle Type',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(child: Column(
          children: [
             textFieldCont('Name (English)', englishnameController,
                  engname ? Colors.red : Colors.black, onChanged: (value) {
                setState(() {
                  engname = false;
                });
              }),
              engname ? validationCont() : Container(),
                textFieldCont('Name (Urdu)', urdunameController,
                  urdname ? Colors.red : Colors.black, onChanged: (value) {
                setState(() {
                  urdname = false;
                });
              }),
              urdname ? validationCont() : Container(),
               InkWell(
                onTap: () {
                  addVehicleType();

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
        onChanged: (value) => onChanged!(value),
      ),
    );
  }
}