import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/dashboard/file_attachment.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class TripManagement extends StatefulWidget {
  TripManagement({Key? key}) : super(key: key);

  @override
  State<TripManagement> createState() => _TripManagementState();
}

class _TripManagementState extends State<TripManagement> {
   TextEditingController searchController = TextEditingController();

  bool loading = true;
  List filterList = [];
  bool isSearching = false;
  var selectedItem;
  int itemIndex = 0;
  List tripList = [];

  deleteTripRecord() async {
    print('Delete');
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "Trip_Delete",
        "value": {"Id": "${selectedItem['id']}", "Language": "en-US"}
      });
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);
      print('???????????????????');

      if (response.statusCode == 200) {
        print('???????????????????');
        var decode = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully deleted.')));
        tripList.removeAt(itemIndex);

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

  getTriptList() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "Trip_GetAll",
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

  tripApiCall() async {
    tripList = await getTriptList();
    loading = false;

    setState(() {});
  }

  @override
  void initState() {
    tripApiCall();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // MyNavigation().push(context, AddVehicleList());
        },
        child: Icon(Icons.add),
        backgroundColor: MyColors.yellow,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: selectedItem == null ? Text('Trip List') : Container(),
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
                                                Navigator.pop(
                                                    context, deleteTripRecord());
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
                        // MyNavigation().push(
                        //     context,
                        //     UpdateVehicle(
                        //       item: selectedItem,
                        //     ));
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
                backgroundColor: MyColors.yellow,
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

                                        List filtered = tripList
                                            .where((item) =>
                                                '${item['tripNumber']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                '${item['projectCode']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                '${item['tripDate']}'
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
                                  color: MyColors.yellow,
                                ))),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: width + 500,
                      child: Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.only(left: 10),
                            color: Color.fromARGB(255, 234, 227, 227),
                            child: tripListCont(
                                '#',
                                ' Trip #',
                                'Trip Date',
                                'Manifesto#',
                                'Plate #',
                                'P. Code',
                               
                                'DM/TC',
                                'Trip Rate','Expense','Remaining ',
                                15,
                                FontWeight.bold),
                          ),
                          Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: isSearching
                                  ? filterList.length
                                  : tripList.length,
                              itemBuilder: (BuildContext context, int index) {
                                int indexx = index + 1;
                                var item = isSearching
                                    ? filterList[index]
                                    : tripList[index];
                                return tripListCont(
                                  '$indexx',
                                  '${item['tripNumber']}',
                                  '${item['tripDate']}',
                                  '${item['manifestoNumber']}',
                                  '${item['vehiclePlatNumber']}',
                                  '${item['projectCode']}',
                                  '${item['dmtcNumber']}',
                                  '${item['projectTripRate']}',
                                  '${item['tripExpense']}',
                                  '${item['remainingExpense']}',


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
                                      ? MyColors.yellow
                                      : Colors.white,
                                         IconData: Icons.attachment,
                                    onTab: () {
                                      print('${item['currentFileName']}');
                                      MyNavigation().push(
                                          context,
                                          FileAttachment(
                                            image: '${item['currentFileName']}',
                                          ));
                                    }
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

  tripListCont(
    String serial,
    String tripN,
    String date,
    String manifesto,
    String platnumber,
    String projectCode,
    String dmtc,
    String triprate,
    String expense,
    String remaining,
    double size,
    FontWeight fontWeight, {
    // String? project,
    Function? onLongPress,
    bgColor,IconData,Function? onTab
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
            margin: EdgeInsets.only(
              left: 8,
            ),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 100,
            child: Text(
              tripN,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Expanded(
            child: Container(
              width: 100,
              child: Text(date,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
              width: 110,
             
              child: Text(manifesto,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
              width: 100,
           margin: EdgeInsets.only(left: 5),
              child: Text(platnumber,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
              width: 100,
           
              child: Text(projectCode,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
              width: 100,
             
              child: Text(dmtc,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
              width: 100,
          
              child: Text(triprate,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
           Expanded(
            child: Container(
              width: 100,
           
              child: Text(expense,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
           Expanded(
            child: Container(
              width: 100,
            
              child: Text(remaining,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          GestureDetector(
            onTap: () => onTab!(),
            child: Container(
            width: 90,

              child: Icon(IconData),
            ),
          ),
        ]),
      ),
    );
  }
}