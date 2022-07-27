import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xtreme_fleet/dashboard/dashboard.dart';
import 'package:xtreme_fleet/dashboard/khata_transaction_list.dart';
import 'package:xtreme_fleet/dashboard/new_khata_list.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Color? dash;
  Color? khata;
  Color? trans;

  List<Widget> widgets = [
    Dashboard(),
    NewKhataList(),
    KhataTransactionList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomAppBar(
      elevation: 5,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: iconCont(
                  FontAwesomeIcons.cruzeiroSign,
                  _selectedIndex == 0 ? MyColors.title : MyColors.cardtxtwhite,
                  'Dashboard',
                  _selectedIndex == 0 ? MyColors.title : MyColors.cardtxtwhite,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: iconCont(
                  FontAwesomeIcons.creditCard,
                  _selectedIndex == 1 ? MyColors.title : MyColors.cardtxtwhite,
                  'Khata',
                  _selectedIndex == 1 ? MyColors.title : MyColors.cardtxtwhite,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: iconCont(
                  FontAwesomeIcons.moneyCheckDollar,
                  _selectedIndex == 2 ? MyColors.title : MyColors.cardtxtwhite,
                  'Transaction',
                  _selectedIndex == 2 ? MyColors.title : MyColors.cardtxtwhite,
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }

  iconCont(IconData icon, Color color, text, Color textcolor,
      {Function? onPress}) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),

              child: Icon(
            icon,
            color: color,
          )),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              text,
              style: TextStyle(color: textcolor),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      // index == 0 ? dash = MyColors.dgreen: MyColors.cardtxtwhite;
      // index == 1 ? khata =MyColors.cardgreen: MyColors.cardtxtwhite;
      // index == 2 ? trans=MyColors.cardgreen: MyColors.cardtxtwhite;

      _selectedIndex = index;
    });
  }
}
