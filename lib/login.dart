import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/dashboard.dart';
import 'package:xtreme_fleet/dashboard/main_screen.dart';
import 'package:xtreme_fleet/resources/app_data.dart';
import 'package:xtreme_fleet/signup.dart';

import 'package:xtreme_fleet/utilities/my_assets.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class Login extends StatefulWidget {
  Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = true;
  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;
  checkbox(bool value) {
    print(value);
    _rememberMe = value;
    setState(() {});
  }

  bool _show = true;
  bool get show => _show;
  passShow() {
    _show = !_show;
    print(_show);
    setState(() {});
  }

  bool log = false;
  bool pass = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final OneContext _context = OneContext.instance;

  loginApi() async {
   // FocusManager.instance.primaryFocus!.unfocus();
    try {
      if (emailController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColors.bgred,
          content: Text(
            'Username required',
          ),
          duration: Duration(seconds: 1),
        ));
      } else if (passController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColors.bgred,
          content: Text(' Password required'),
          duration: Duration(seconds: 1),
        ));
      }
     
      else if (emailController.text != 'user' ||
          passController.text != 'user') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColors.bgred,
          content: Text('Invalid username or password'),
          duration: Duration(milliseconds: 500),
        ));
      } else if (emailController.text == 'user' &&
          passController.text == 'user') {
        _context.showProgressIndicator(
            circularProgressIndicatorColor: MyColors.dgreen);
        Map body = {
          'type': 'UserManagement_ValidateCredenial',
          'value': {
            'Email': emailController.text.trim(),
            'Password': passController.text.trim(),
            'Language': 'en-US',
          }
        };
        print(body);
        var response = await http.post(
            Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process/'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body));
        _context.hideProgressIndicator();

        print(response.statusCode);
        print(response.body);
        var decode = json.decode(response.body);
        print(decode);
        if (response.statusCode == 200) {
          if (decode['Value'] == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: MyColors.bgred,
                content: Text('Invalid Credentails.')));
            return null;
          }

          print(decode);
          print(decode['Value']);
          print('<<<<<<<<<>>>>>>>>>>>>>>>>>');

          var dodecode = json.decode(decode['Value'])["username"];
          print(dodecode);

          print('<<<<<<<<<>>>>>>>>>>>>>>>>>');

          return json.decode(decode['Value']);
        }
        //  else {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       backgroundColor: MyColors.bgred,
        //       content: Text('Invalid username or password')));
        // }
      }
    } catch (e) {
      _context.hideProgressIndicator();

      print(e);
      print('ssssssssssssssssss');
      return null;
    }
  }

  userLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    print('false??????????????');
    var response = await loginApi();
    print(response);
    if (response == null) {
      return Text('Invalid Login');
    } else {
      AppData.instance.setUserData(response);
      print('cccccccccccccccccccc');
      MyNavigation().push(context, MainScreen());
    }
  }

  final Box _box=Hive.box("CRED");
  @override
  void initState() {
    emailController.text=_box.get('username',defaultValue: '');
    passController.text=_box.get('password',defaultValue: '');

    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    //AuthProvider _authpro = Provider.of(context, listen: false);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(
            horizontal: 35,
          ),
          decoration: BoxDecoration(
        //      gradient: LinearGradient(colors: [
          
          
        //   MyColors.cardgreen.withOpacity(0.1),
        //   MyColors.cardgreen.withOpacity(0.1),


         


          
         



        // ], end: Alignment.bottomCenter, begin: Alignment.topCenter),
            image: DecorationImage(
                image: AssetImage(MyAssets.khatabg), fit: BoxFit.cover),
           ),
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Container(
                
                  height: 50,
                  child: Image.asset(MyAssets.logo)),
                  SizedBox(
                height: 90,
              ),
              Container(
             
                child: Column(
                  children: [
                    textFieldCont('Username', 'Username', Icons.person, false,
                        emailController),
                    textFieldCont(
                      'Password',
                      'Password',
                      show ? Icons.visibility : Icons.visibility_off,
                      show,
                      passController,
                      onPassShowHide: () => passShow(), //.trim()
                    ),
                  ],
                ),
              ),
     
           
              InkWell(
                
                onTap: ()  {
                  _box.put('username',emailController.text);
                  _box.put('password',passController.text);

                  userLogin();},
                child: Container(
          
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 30),
                  height: 40,
                  width: width,
                  decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
                    
                    color: MyColors.cardgreen),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                        color: MyColors.dgreen,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
           
            ],
          ),
        ),
      ),
    );
  }


  textCont(String text) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10),
      child: Text(text),
    );
  }

  textFieldCont(
    String label,
    String hint,
    IconData icon,
    bool secure,
    TextEditingController controller, {
    Function? onPassShowHide,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 50,
      decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: MyColors.grey

      ),
      child: Container(
        margin: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
       
        child: TextFormField(
          controller: controller,
          cursorColor: Colors.black,
          obscureText: secure,
          decoration: InputDecoration(
            focusColor: MyColors.dgreen,
            hintText: hint,
            hintStyle: TextStyle(color: MyColors.cardtxtgreen, fontSize: 12),
            suffixIcon: GestureDetector(
              onTap: () => onPassShowHide!(),
              child: Icon(
                icon,
                color: MyColors.cardtxtgreen,
                size: 18,
              ),
            ),
            border: InputBorder.none
        
          ),
        ),
      ),
    );
  }
}
