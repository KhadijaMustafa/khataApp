import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_colors.dart';

class ProjectDocuments extends StatefulWidget {
  final String? entityName;
  final String? documentType;
  final String? vehId;
  final String? proId;
  ProjectDocuments(
      {Key? key, this.documentType, this.entityName, this.vehId, this.proId})
      : super(key: key);

  @override
  State<ProjectDocuments> createState() => _ProjectDocumentsState();
}

class _ProjectDocumentsState extends State<ProjectDocuments> {
  TextEditingController searchController = TextEditingController();
  List filtered = [];

  List proDetailList = [];
  bool _loading = true;
  List filterList = [];
  bool isSearching = false;
  employeeApi({
    String? vehId,
    String? proId,
  }) async {
    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "Dashboard_Get",
            "value": {
              "Entity": "${widget.entityName}",
              "DocumentType": "${widget.documentType}",
              "Flag": "List",
              "Language": "en-US",
            }
          }));
      var decode = json.decode(response.body);
      if (response.statusCode == 200) {
        var doDecode = json.decode(decode['Value']);
        print(doDecode);
        return doDecode;
      } else {
        return false;
      }
    } catch (e) {
      return print(e);
    }
  }

  empdocument() async {
    proDetailList = await employeeApi(
      proId: 'id',
    );
    _loading = false;
    setState(() {});
  }

  @override
  void initState() {
    empdocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.yellow,
        elevation: 0,
        title: Text(
          'Expired Document Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: MyColors.yellow,
              ),
            )
          : Container(
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    //margin: EdgeInsets.all(10),
                    // height: 50,
                    child: Container(
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

                                        List filtered = proDetailList
                                            .where((item) =>
                                                '${widget.entityName == 'Employee' ? item['employeeName'] : widget.entityName == 'Vahicle' ? item['platNumber'] : item['projectCode']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                '${item['documentType']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()) ||
                                                '${item['projectName']}'
                                                    .toLowerCase()
                                                    .contains(searchController
                                                        .text
                                                        .toLowerCase()))
                                            .toList();
                                        print('project');
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
                  Container(
                    padding: EdgeInsets.all(8),
                    //margin: EdgeInsets.all(10),
                    color: Color.fromARGB(255, 234, 227, 227),
                    child: empDocCont('#',
                      'Code',
                      'Name',
                      'Document',
                      'Expiry Date',
                      'Status',
                      13,
                      FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: isSearching
                          ? filterList.length
                          : proDetailList.length,
                      itemBuilder: (BuildContext context, int index) {
                        int indexx=index=1;
                        var item = isSearching
                            ? filterList[index]
                            : proDetailList[index];
                        return empDocCont('$indexx',
                            '${item['projectCode']}',
                            '${item['projectName']}',
                            '${item['documentType']}',
                            '${item['expiryDate']}',
                            '${item['expired']}',
                            11,
                            FontWeight.normal);
                      },
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [],
                    ),
                  )
                ]),
              ),
            ),
    );
  }

  empDocCont(
    String serial,
    String title,
    String document,
    String projectName,
    String expiryDate,
    String status,
    double size,
    FontWeight fontWeight, {
    String? project,
  }) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 10, top: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 15,
            margin: EdgeInsets.only(left: 8,right: 8),
            child: Text(
              serial,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
        Expanded(
          child: Container(
            child: Text(
              title,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Text(projectName,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
        ),
        Expanded(
          child: Container(
            child: Text(document,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(expiryDate,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(status,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
        ),
      ]),
    );
  }
}
