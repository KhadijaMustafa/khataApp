import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xtreme_fleet/login.dart';
import 'package:xtreme_fleet/utilities/my_assets.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      return MyNavigation().push(context, Login());
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          height: height,
          // width: width,
          decoration: BoxDecoration(
                image: DecorationImage(
                   image: AssetImage(MyAssets.ss), fit: BoxFit.cover),

          ),
        child: Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          decoration: BoxDecoration(
            
              gradient: LinearGradient(colors: [
                
            
          
              MyColors.cardgreen.withOpacity(0.2),
              MyColors.grey.withOpacity(0.6),
            

           
              

              
              
            
      
              MyColors.cardgreen.withOpacity(0.6),
            

              

             
             
              
      
           
      
              
            
          ], end: Alignment.bottomLeft, begin: Alignment.topRight)
          ),
          child: Container(height: 70, child: Image.asset(MyAssets.logo)),
        ),
      ),
    );
  }
}
