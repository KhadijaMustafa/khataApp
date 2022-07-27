import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/dashboard/add_project_list.dart';
import 'package:xtreme_fleet/dashboard/update_project.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class ProjectList extends StatefulWidget {
  ProjectList({Key? key}) : super(key: key);

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  TextEditingController searchController = TextEditingController();

  bool loading = true;
  List filterList = [];
  bool isSearching = false;
  var selectedItem;
  int itemIndex = 0;
  List projectList = [];

  deleteProject() async {
    print('Delete');
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "Project_Delete",
        "value": {"Id": "${selectedItem['id']}"}

        
      });
      request.headers.addAll(headers);

      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        print('???????????????????');
        var decode = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully deleted.')));
        projectList.removeAt(itemIndex);

        setState(() {
          selectedItem = null;
        });
        print('Deleted');
        print(decode);
      }
    } catch (e) {}
  }

  getProjectList() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "Project_GetAll",
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

  projectApiCall() async {
    projectList = await getProjectList();
    loading = false;

    setState(() {});
  }

  @override
  void initState() {
    projectApiCall();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyNavigation().push(context, AddProjectList());
        },
        child: Icon(Icons.add),
        backgroundColor: MyColors.yellow,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: selectedItem == null ? Text('Project List') : Container(),
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
                                                    context, deleteProject());
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
                            UpdateProject(
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

                                        List filtered = projectList
                                            .where((item) =>
                                                '${item['code']}'.toLowerCase().contains(searchController.text.toLowerCase()) ||
                                                '${item['name']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                '${item['fromSite']}'
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
                      width: width+200,
                      child: Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.only(left: 10),
                            color: Color.fromARGB(255, 234, 227, 227),
                            child: vehicleListCont(
                                '#',
                                'Code',
                                ' Name',
                                'From Site',
                                'Trips',
                                'Date',
                                'Customer',
                                14,
                                FontWeight.bold),
                          ),
                          Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: isSearching
                                  ? filterList.length
                                  : projectList.length,
                              itemBuilder: (BuildContext context, int index) {
                                int indexx = index + 1;
                                var item = isSearching
                                    ? filterList[index]
                                    : projectList[index];
                                return vehicleListCont(
                                  '$indexx',
                                  '${item['code']}',
                                  '${item['name']}',
                                  '${item['fromSite']}',
                                  '${item['totalTrips']}',
                                  '${item['startDate']}',
                                  '${item['customerName']}',
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
    String code,
    String name,
    String fromsite,
    String trips,
    String date,
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 15,
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                code,
                style: TextStyle(fontSize: size, fontWeight: fontWeight),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(name,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
             
              child: Text(fromsite,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
        
              child: Text(trips,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
             
              child: Text(date,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
          Expanded(
            child: Container(
             
              child: Text(customer,
                  style: TextStyle(fontSize: size, fontWeight: fontWeight)),
            ),
          ),
        ]),
      ),
    );
  }
}
