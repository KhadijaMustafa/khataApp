import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
class StackWidget extends StatefulWidget {
  StackWidget({Key? key}) : super(key: key);

  @override
  State<StackWidget> createState() => _StackWidgetState();
}

class _StackWidgetState extends State<StackWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey,
      body: Container(
        
        child: Container(
          alignment: Alignment.center,
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              
              Positioned(
                top: 50,
                left:60,
               
                child: Card(
                    shadowColor: Colors.white.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: MyColors.grey.withOpacity(0.1)),
            ),
            elevation: 50,
                  child: Container(
                   padding: EdgeInsets.all(10),
                   // color: Colors.red[400],
                    child:   Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  
                 Container(
                        margin: EdgeInsets.only(top: 20),    
                     // alignment: Alignment.topLeft,
                     child: Text(
                       '1',
                       overflow: TextOverflow.ellipsis,
                       style: TextStyle(
                           color: MyColors.cardtxtgreen,
                           fontSize: 16,
                           fontWeight: FontWeight.w500),
                     ),
                   ),
                   
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10,bottom: 10),
                      width: 130,
                      child: Text(
                        'text',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                           
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                  ),
                ),
              ),
              Positioned(
                bottom: 170,
                left: 120,
             
                
                child: Container(
                       width: 40,
                height: 40,
                         alignment: Alignment.topCenter,          
                    margin: EdgeInsets.only(bottom: 5),
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: Colors.white,
                       border: Border.all(color: MyColors.bggreen)
                     ),
                      child: Icon(
                        Icons.ac_unit,
                        color: MyColors.bggreen,
                        size: 20,
                      ),
                    ),
                
                
                
              
              ),
            ],
      ),
        )),
    );
  }
  cardCont(){
    return ;
  }
}