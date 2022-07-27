import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/dashboard/site_add.dart';
import 'package:xtreme_fleet/dashboard/update_site.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';
class SetUpSite extends StatefulWidget {
  SetUpSite({Key? key}) : super(key: key);

  @override
  State<SetUpSite> createState() => _SetUpSiteState();
}

class _SetUpSiteState extends State<SetUpSite> {
   TextEditingController searchController = TextEditingController();
  List setupList = [];
  bool loading = true;
  List filterList = [];
  bool isSearching = false;
  var selectedItem;
  int itemIndex = 0;
  
  int count = 1;
  getSiteList() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "Site_GetAll",
        "value": {"Language": "en-US"}
      });
      // print('${selectedItem['id']}');
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print(decode);
        print('Successssssssssssssss');

        print(decode['Value']);
        return json.decode(decode['Value']);
        //json.decode(decode['Value']);

      }
    } catch (e) {
      print(e);
    }
  }

  siteCallApi() async {
    setupList = await getSiteList();
    loading = false;

    setState(() {});
  }

  @override
  void initState() {
    siteCallApi();

    super.initState();
  } //



   deleteSite() async {
    print('Delete');
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
       "type": "Site_Delete",
  "value": {
    "Id": "${selectedItem['id']}",
    "UserId": "f14198a1-1a9a-ec11-8327-74867ad401de",
    "Language": "en-US"
  }
      });
      

      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

        print('???????????????????');

      //print("${selectedItem['id']}");
        print('???????????????????');

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully deleted.')));
        setupList.removeAt(itemIndex);

        setState(() {
          selectedItem = null;
        });
        print('Deleted');
        print(decode);
      }
    } catch (e) {}
  }
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          //getVehExpense();
          MyNavigation().push(context, SiteAdd());
        },
        child: Icon(Icons.add),
        backgroundColor: MyColors.yellow,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title:
            selectedItem == null ? Text('Site List') : Container(),
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
                                                Navigator.pop(
                                                    context, deleteSite());
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
                              UpdateSite(
                                item: selectedItem,
                              ));
                        },
                        child: actionIcon(FontAwesomeIcons.penToSquare)),
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
                          left: 20, top: 4, bottom: 4, right: 20),
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

                                        List filtered = setupList
                                            .where((item) =>
                                                '${item['site']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                
                                                '${item['customerName']}'
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
                      width: width,
                      child: Column(
                        children: [
                           Container(
                    
                      color: Color.fromARGB(255, 234, 227, 227),
                      child: supplierCont('#', 'Site', 'Customer Name',
                           14, FontWeight.bold),
                  ),
                       Container(
                      //padding: EdgeInsets.only(left: 5, right: 5),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount:
                            isSearching ? filterList.length : setupList.length,
                        itemBuilder: (BuildContext context, int index) {
                          int indexx = index + 1;
                          var item = isSearching
                              ? filterList[index]
                              : setupList[index];
                         
                          return supplierCont(
                            '$indexx',
                            '${item['site']}',
                            '${item['customerName']}',
                            
                            12,
                            FontWeight.normal,
                            onLongPress: () {
                              print('object');

                              setState(() {
                                selectedItem = item;
                                itemIndex = index;
                              
                              });
                            },
                            bgColor: '${selectedItem}' == '${item}'
                                ? MyColors.yellow
                                : Colors.white,
                          );
                        },
                      ),
                  )

                        ],
                      ),
                    ),
                  )
                 
               
                ],
              )),
            ),

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

  supplierCont(
    String serial,
    String site,
    String customer,
   
    double size,
    FontWeight fontWeight, {
    // String? project,
    Function? onLongPress,
    bgColor,
  }) {
    return GestureDetector(
      onLongPress: () => onLongPress!(),
      child: Container(
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(5),
        child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
            children: [
              


          Container(
            width: 25,
            margin: EdgeInsets.only(left: 8,),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 120,

            child: Text(
              site,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 150,

            child: Text(customer,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
         
      
        ]),
      ),
    );
  }
}