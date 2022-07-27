import 'package:flutter/material.dart';
import 'package:xtreme_fleet/components/api_list.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
class GetList extends StatefulWidget {
  GetList({Key? key}) : super(key: key);

  @override
  State<GetList> createState() => _GetListState();
}

class _GetListState extends State<GetList> {
  List vehicleList=[];
//    vehicleApiCall() async {
//  ApiList(type: "Employee_GetAll",mainList: vehicleList,loading: false,);

//     setState(() {});
//   }

  @override
  void initState() {
   ApiList(type: 'Employee_GetAll',);
print('///////////////////////');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.red,
      appBar: AppBar(),
    );
  }
}