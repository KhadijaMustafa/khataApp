import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/dashboard/add_khata.dart';
import 'package:xtreme_fleet/dashboard/khata_report.dart';
import 'package:xtreme_fleet/dashboard/update_khata.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class NewKhataList extends StatefulWidget {

  NewKhataList({Key? key,}) : super(key: key);

  @override
  State<NewKhataList> createState() => _NewKhataListState();
}

class _NewKhataListState extends State<NewKhataList> {
  TextEditingController searchController = TextEditingController();
  List supplierList = [];
  bool loading = true;
  List filterList = [];
  bool isSearching = false;
  var selectedItem;
  int itemIndex = 0;
  List customerKhataList = [];
  var khatadetail;



  deleteCustomerKhata() async {
    try {
      print('Delete');
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
       "type": "KhataCustomer_Delete",
  "value": {
    "Id": "${selectedItem['id']}",
    "Language": "en-US"
  }
      });
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);
      print('???????????????????');
if(response.statusCode==200){
      print('???????????????????');
      var decode = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColors.bggreen,
          content: Text('Record succesfully deleted.')));
      customerKhataList.removeAt(itemIndex);

      setState(() {
        selectedItem = null;
      });
      print('Deleted');
      print(decode);
}
    } catch (e) {
      print(e);
    }
  }

  getCustometKhata() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "KhataCustomer_GetAll",
        "value": {
          "Language": "en-US",
          "Id": "9eb1b314-64d7-ec11-9168-00155d12d305"
        }
      });

      request.headers.addAll(headers);
      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('Successssssssssssssss');
        print(decode['Value']);
        print(response.body);
        return json.decode(decode['Value']);
      }
    } catch (e) {
      print(e);
    }
  }

  customerKhataApiCall() async {
    customerKhataList = await getCustometKhata()??[];
    loading = false;

    setState(() {});
  }

  @override
  void initState() {
    customerKhataApiCall();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyNavigation().push(context, AddKhata());
        },
        child: Icon(Icons.add),
        backgroundColor: MyColors.title,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.title,
        title: selectedItem == null ? Text('Khata List') : Container(),
        actions: [
          selectedItem == null
              ? Container()
              : Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //title: Text('data'),
                                  content: Text(
                                    'Do you want to delete this record?',
                                    style: TextStyle(
                                        color: MyColors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: MyColors.bgred),
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Text('No',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .bold)))),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context,
                                                    deleteCustomerKhata());
                                                setState(
                                                    () => selectedItem = null);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: MyColors.bggreen),
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
                        child: actionIcon(
                          Icons.delete,
                        )),
                    GestureDetector(
                      onTap: () {
                        MyNavigation().push(
                            context,
                            UpdateKhata(
                              item: selectedItem,
                            ));
                      },
                      child: actionIcon(FontAwesomeIcons.penToSquare),
                    ),
                    GestureDetector(
                        onTap: () => setState(() => selectedItem = null),
                        child: actionIcon(Icons.close)),
                  ],
                )
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: MyColors.cardtxtgreen,
              ),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      //margin: EdgeInsets.all(10),
                      // height: 50,
                      child: Container(
                        height: 45,
                        padding: EdgeInsets.only(
                            left: 20, top: 5, bottom: 4, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: MyColors.grey)),
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: TextFormField(
                          cursorColor: MyColors.black,
                          controller: searchController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search here .........',
                              suffixIcon: GestureDetector(
                                  onTap: isSearching
                                      ? () {
                                          searchController.clear();
                                          setState(() {
                                            isSearching = false;
                                          });
                                        }
                                      : () {
                                          setState(() {
                                            isSearching = true;
                                            filterList.clear();
                                          });
              
                                          List filtered = customerKhataList
                                              .where((item) =>
                                                  '${item['address']}'
                                                      .toLowerCase()
                                                      .contains(searchController
                                                          .text
                                                          .toLowerCase()) ||
                                                  '${item['nameEng']}'
                                                      .toLowerCase()
                                                      .contains(searchController
                                                          .text
                                                          .toLowerCase()) ||
                                                  '${item['contactNumber']}'
                                                      .toLowerCase()
                                                      .contains(searchController
                                                          .text
                                                          .toLowerCase()))
                                              .toList();
              
                                          print(filtered);
                                          setState(() {
                                            filterList = filtered;
                                          });
                                        },
                                  child: Icon(
                                    isSearching ? Icons.close : Icons.search,
                                    size: 30,
                                    color: MyColors.cardtxtgreen,
                                  ))),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                    
                      
                      child: Container(
                        width: width +200,
                      
                        child: Column(
                          children: [
                            /////////  
                               


                            /////////
                            Container(
                        // padding: EdgeInsets.only(left: 10),
                        color: Color.fromARGB(255, 234, 227, 227),
                        child: vehicleListCont(
                            '#',
                            'Khata #',
                            ' Name',
                            'Contact #',
                            'Address',
                            15,
                            FontWeight.bold),
                    ),
                         Container(
                       
              
                        child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: isSearching
                              ? filterList.length
                              : customerKhataList.length,
                          itemBuilder: (BuildContext context, int index) {
                            int indexx = index + 1;
                            var item = isSearching
                                ? filterList[index]
                                : customerKhataList[index];
                                var item2=customerKhataList[index];
                            return vehicleListCont(
                              '$indexx',
                              '${item['khataNumber']}',
                              '${item['nameEng']}',
                              '${item['contactNumber']}',
                              '${item['address']}',
                              12,
                              FontWeight.w400,
                              onLongPress: () {
                                print('object');
                                print(item);
                        
                                setState(() {
                                  print('???///////////');
                                  print(selectedItem);
                                  selectedItem = item;
                                  itemIndex = index;
                                });
                              },
                              bgColor: '${selectedItem}' == '${item}'
                                  ? MyColors.cardgreen
                                  : Colors.white,
                                  onTab: (){
                                    setState(() {
                                      khatadetail=item2;
                                    });
                                    MyNavigation().push(context, KhataReport(item: khatadetail,));
                                  },Color: MyColors.blue
                            );
                          },
                        ),
                    )
                            
                          ],
                        ),
                      ),
                    )
                    
                 
                  ],
                ),
              )),
    );
  }

  actionIcon(IconData) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: Icon(
        IconData,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  vehicleListCont(
    String serial,
    String khataNum,
    String name,
    String contact,
    String address,
    double size,
    FontWeight fontWeight, {
    // String? project,
    Function? onLongPress,
    bgColor,
    Function? onTab,
    Color 
  }) {
    return GestureDetector(
      onLongPress: () => onLongPress!(),
      child: Container(
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 25,
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          InkWell(
            onTap: ()=>onTab!(),
            child: Container(
            width: 120,

              child: Text(
                khataNum,
                style: TextStyle(fontSize: size, fontWeight: fontWeight,color: Color),
              ),
            ),
          ),
          Container(
            width: 100,

            child: Text(name,
                style: TextStyle(fontSize: size, fontWeight: fontWeight,)),
          ),
          Container(
            width: 100,

            margin: EdgeInsets.only(left: 5),
            child: Text(contact,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,

            margin: EdgeInsets.only(left: 5),
            child: Text(address,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
        ]),
      ),
    );
  }
}
