import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xtreme_fleet/components/button_widget.dart';
import 'package:xtreme_fleet/components/check_button.dart';
import 'package:xtreme_fleet/components/checkbox_widget.dart';
import 'package:xtreme_fleet/components/date_widget.dart';
import 'package:xtreme_fleet/components/delete_function.dart';
import 'package:xtreme_fleet/components/dropdowm_widget.dart';
import 'package:xtreme_fleet/components/main_provider.dart';
import 'package:xtreme_fleet/components/search_widget.dart';
import 'package:xtreme_fleet/components/text_widget.dart';
import 'package:xtreme_fleet/components/textfield_widget.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';

class TestComponent extends StatefulWidget {
  TestComponent({Key? key}) : super(key: key);

  @override
  State<TestComponent> createState() => _TestComponentState();
}

class _TestComponentState extends State<TestComponent> {
  TextEditingController textController = TextEditingController();
  bool search=false;
  
  List<String> nameList = [
    'Usman',
    'Tayab',
    'Ali',
  ];
  var onchangevalue;
  @override
  Widget build(BuildContext context) {
    MainProvider mainpro=Provider.of(context,listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              child: TextWidget(
                text: 'TextComponent',
                textcolor: MyColors.black,
                size: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Container(
               margin:
                      EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 20),
                  alignment: Alignment.center,
              child: ButtonWidget(
                bgcolor: MyColors.yellow,
                size: 24,
                text: 'Save',
                height: 50,
               fontWeight: FontWeight.bold,
                borderradius: BorderRadius.circular(30),
                textcolor: MyColors.red,
              ),
            ),
            Container(
              child: DropdowmWidget(
                hinttext: '--select--',
                list: nameList,
                onchanged: (value) {
                  setState(() {
                    onchangevalue = value;
                  });
                },
                bordercolor: MyColors.black,
              ),
            ),
            Container(
              child: TextFieldWidget(
              
                bordercolor: MyColors.black,
                borderradius: BorderRadius.circular(20),
                controller: textController,
                keyboardtype: TextInputType.name,onChanged: (value){
                  setState(() {
                    
                  });
                },height: 40,hinttext: 'Enter your name',
              ),
            ),
            SizedBox(height: 20,),

            Consumer<MainProvider>(
              builder: (context,prov,child) {
                return CheckboxWidget(ischecked:prov.check ,onTab: (value)=>mainpro.checkbox(value),bordercolor: MyColors.black,iconcolor: MyColors.red,);
              }
            ),
            SizedBox(height: 20,),
            SearchWidget(iconcolor: MyColors.black,isSearching: search,searchController: TextEditingController(),searchItem: (){},size: 20,),
            SizedBox(height: 20,),
            DeleteFunction(deleteF: (){
              
            },),
            SizedBox(height: 20,),
            // Consumer<MainProvider>(
            //   builder: (context,provi,chil) {
            //     return DateWidget(selectedDate: DateTime.now(),pickedDate:provi.getDate() ,);
            //   }
            // ),
         //   DateWidget(setdate: false,selectedDate: DateTime.now(),)

       
          ],
        )),
      ),
    );
  }
}
