import 'package:flutter/material.dart';
class DropdowmWidget extends StatelessWidget {
  final Color? bordercolor;
  final String? hinttext;
  final Function? onchanged;
  final List? list;
  final String? dropdowntext;
  
  const DropdowmWidget({Key? key,this.bordercolor,this.hinttext,this.list,this.onchanged,this.dropdowntext,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     height: 50,
    //     padding: EdgeInsets.only(left: 20, right: 20),
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(30),
    //         border: Border.all(
    //           color: bordercolor!,
    //         )),
    //     margin: EdgeInsets.only(left: 20, top: 25, right: 20),
    //     child: DropdownButtonFormField(
    //       autovalidateMode: AutovalidateMode.onUserInteraction,
    //       isExpanded: true,
    //       decoration: InputDecoration(
    //           border: InputBorder.none,
    //           filled: false,
    //           hintStyle: TextStyle(color: Colors.black54),
    //           hintText: '$hinttext',
    //           fillColor: Colors.white),
    //       onChanged: (value) =>onchanged!(value),
    //       items: list
    //           ?.map((item) => DropdownMenuItem(
    //               value: item, child: Text("${item[dropdowntext]}")))
    //           .toList(),
    //     ));
    return Container(

      
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: bordercolor!,
                    )),
                margin: EdgeInsets.only(left: 20, top: 25, right: 20),
                child: DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
            

                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      hintStyle: TextStyle(color: Colors.black54),
                      hintText: 
                          '$hinttext',
                          
                      fillColor: Colors.white),
                  
                         onChanged: (value){onchanged;},

                items: list
                      ?.map((valueTitle ) => DropdownMenuItem(
                          value: valueTitle, child: Text("$valueTitle")))
                      .toList(),
                
              ));
  }
}