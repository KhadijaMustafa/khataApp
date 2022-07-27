import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtreme_fleet/dashboard/add_customer_trans.dart';
import 'package:xtreme_fleet/dashboard/file_attachment.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:xtreme_fleet/utilities/my_navigation.dart';

class KhataReport extends StatefulWidget {
  final item;

  KhataReport({
    Key? key,
    this.item,
  }) : super(key: key);

  @override
  State<KhataReport> createState() => _KhataReportState();
}

var listitem;

class _KhataReportState extends State<KhataReport> {
  var khata;
  var contact;
  var nameeng;
  var nameurd;
  var addresseng;
  var addressurd;
  double valuee = 0;
  bool loading = true;
  double debit = 0;
  double credit = 0;
  double remaining = 0;
  DateTime startDate = DateTime.utc(2022);
  DateTime selectedDate = DateTime.now();
  var selectItem;
  var customername;

  double totalAmount = 0.0;
  List reportList = [];
  var listvalues;

  // getListValues() async {
  //   try {
  //     var response = await http.post(
  //         Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
  //         headers: {'Content-Type': 'application/json'},
  //         body: json.encode({
  //           "type": "KhataCustomer_GetById",
  //           "value": {"Language": "en-US", "Id": '${widget.item['id']}'}
  //         }));

  //     var decode = json.decode(response.body);
  //     print('Successssssssssssssss');
  //     print(decode['Value']);
  //     print(response.body);

  //     listvalues = json.decode(decode['Value']);

  //     khata = listvalues["khataNumber"];
  //     contact = listvalues["contactNumber"];

  //     nameeng = listvalues["nameEng"];
  //     nameurd = listvalues["nameUrd"];
  //     addresseng = listvalues["addressEng"];
  //     addressurd = listvalues["addressUrd"];

  //     print('//////////////////////////////////');
  //     print(listvalues);

  //     print('//////////////////////////////////');
  //     setState(() {
  //       listvalues;
  //     });
  //   } catch (e) {}
  // }

  getCustomerReportList() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
        "type": "Transaction_Report_GetByKhata",
        "value": {
          "KhataId": "${widget.item["id"]}",
          "StartDate": CusDateFormat.getDate(startDate),
          "EndDate": CusDateFormat.getDate(selectedDate),
          "Language": "en-US"
        }
      });

      request.headers.addAll(headers);
      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('Success');
        print(decode['Value']);
        print(response.body);
        return json.decode(decode['Value']);
      }
    } catch (e) {
      print(e);
    }
  }

  reportApiCall() async {
    reportList = await getCustomerReportList();
    loading = false;
    calculateTotal();
    print('totalAmount');

    print('totalAmount');
    setState(() {});
  }

  @override
  void initState() {
    // getListValues();
    reportApiCall();
    print('listitem');
    print('${widget.item['id']}');
    print('listitem');
    khata = widget.item["khataNumber"];
    contact = widget.item["contactNumber"];

    nameeng = widget.item["nameEng"];
    nameurd = widget.item["nameUrd"];
    addresseng = widget.item["addressEng"];
    addressurd = widget.item["addressUrd"];
    calculateTotal();
    super.initState();
  }

  calculateTotal() {
    reportList.forEach((element) {
      totalAmount = totalAmount + element['total'];
      debit = debit + element['debit'];
      credit = credit - element['credit'];
      print(totalAmount);
      print('totalAmount');

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyNavigation().push(
              context,
              AddCustomerTransaction(
                items: widget.item,
                // data: listvalues,
              ));
        },
        child: Icon(Icons.add),
        backgroundColor: MyColors.title,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
          color: MyColors.title,
borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30) )

          ),
          padding: EdgeInsets.all(8),
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      margin: EdgeInsets.only(left: 15),
                      child: textCont(
                        'Debit :',
                        15,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 15),
                          child: textCont('$debit'.split('.').first, 16, color: MyColors.dgreen)),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 15),
                        child: textCont(
                          'Credit :',
                          15,
                        )),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: textCont('$credit'.split('.').first, 16, color: MyColors.dgreen),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: textCont(
                        'Remaining :',
                        15,
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 15),
                          child:
                              textCont('$totalAmount'.split('.').first, 16, color: MyColors.dgreen)),
                    ),
                  ],
                ),
              )

              //calculateAmount()
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.title,
        title: Text(
          'Khata',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: MyColors.title,
              ),
            )
          : Container(
              child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 5, bottom: 10),
                    child: Column(children: [
                      detailsCont('Khata #', '$khata'),
                      detailsCont('Contact Number', '$contact'),
                      detailsCont('Name (English)', '$nameeng'),
                      detailsCont('Name (Urdu)', '$nameurd'),
                      detailsCont('Address (English)', '$addresseng'),
                      detailsCont('Address (Urdu)', '$addressurd'),
                    ]),
                  ),
                  // Container(
                  //   width: width,
                  //   margin: EdgeInsets.only(top: 10, right: 5, left: 5),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       cardCont( ' Debit', '$debit',
                  //       ),
                  //       cardCont( ' Credit', '$credit',
                  //           ),
                  //       cardCont( ' Remaining', '$totalAmount',
                  //           ),
                  //     ],
                  //   ),
                  // ),
                  Divider(
                    endIndent: 10,
                    indent: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      " $nameeng 's  khata Detail ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                //child: Text('day-mon-year'),
                                child:
                                    Text('${CusDateFormat.getDate(startDate)}'),
                              ),
                              InkWell(
                                onTap: () async {
                                  DateTime? date = await showDatePicker(
                                      context: context,
                                      fieldHintText: 'day-mon-year',
                                      initialDate: DateTime.utc(2022),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025));
                                  if (date != null) {
                                    setState(() {
                                      startDate = date;
                                    });
                                    print(date);
                                    print(CusDateFormat.getDate(date));
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 35, right: 5),
                                  child: Icon(
                                    Icons.calendar_month,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                //child: Text('day-mon-year'),
                                child: Text(
                                    '${CusDateFormat.getDate(selectedDate)}'),
                              ),
                              InkWell(
                                onTap: () async {
                                  DateTime? date = await showDatePicker(
                                      context: context,
                                      fieldHintText: 'year-mon-day',
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2025));
                                  if (date != null) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                    print(date);
                                    print(CusDateFormat.getDate(date));
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 35, right: 5),
                                  child: Icon(Icons.calendar_month),
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            reportApiCall();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: MyColors.title),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      width: width + 355,
                      child: Column(
                        children: [
                          Container(
                            //padding: EdgeInsets.all(5),
                            //margin: EdgeInsets.all(5),
                            color: Color.fromARGB(255, 234, 227, 227),
                            child: vehExpCont(
                                '#',
                                'Customer',
                                ' Paid Date',
                                ' Remarks',
                                'Debit',
                                'Credit',
                                'Total',
                                15,
                                FontWeight.bold,attachment: 'Attachment',textwidth: 90,iconwidth: 0),
                          ),
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              // scrollDirection: Axis.vertical,
                              itemCount: reportList.length,
                              itemBuilder: (BuildContext context, int index) {
                                int indexx = index + 1;
                                var item = reportList[index];

                                // return Container();
                                return vehExpCont(
                                    '$indexx',
                                    '$nameeng',
                                    '${item['date']}',
                                    '${item['reason']}',
                                    '${item['debit']}',
                                    '${item['credit']}',
                                    '${item['total']}',
                                    12,
                                    FontWeight.normal, onLongPress: () {
                                  setState(() {
                                    selectItem = item;
                                    print('selectItem');

                                    print(selectItem);
                                    print('selectItem');
                                  });
                                },  IconData: Icons.attachment,
                                    onTab: () {
                                      print('${item['currentFileName']}');
                                      MyNavigation().push(
                                          context,
                                          FileAttachment(
                                            image: '${item['currentFileName']}',
                                          ));
                                    },attachment: '',textwidth: 0,iconwidth: 70);
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

  detailsCont(String title, String detail) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            alignment: Alignment.topLeft,
            child: Text(title,
                style: TextStyle(
                    color: MyColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              width: 150,
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              alignment: Alignment.topLeft,
              child: Text(detail,
                  style: TextStyle(
                      color: MyColors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  cardCont(
    String text,
    String count,
  ) {
    return Card(
      // color: Color.fromRGBO(104, 191, 123, 1),
      shadowColor: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
        side: BorderSide(color: MyColors.grey.withOpacity(0.1)),
      ),
      elevation: 0,
      child: Container(
        alignment: Alignment.centerLeft,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              alignment: Alignment.centerLeft,
              child: Text(text,
                  style: TextStyle(
                      color: MyColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(count,
                  style: TextStyle(
                      color: MyColors.title,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),

            // Container(
            //   margin: EdgeInsets.only(top: 5),
            //   child: LinearProgressIndicator(
            //     value: valuee,

            //      valueColor: AlwaysStoppedAnimation<Color>(MyColors.red),
            //   backgroundColor: MyColors.grey,
            //   ),

            // )
          ],
        ),
      ),
    );
  }

  vehExpCont(
    String serial,
    String customer,
    String date,
    String remarks,
    String debit,
    String credit,
    String total,
    double size,
    FontWeight fontWeight, {
    String? project,
    Function? onLongPress,
    bgColor,IconData,
      Function? onTab,
      String? attachment,double? textwidth,double? iconwidth
  }) {
    return GestureDetector(
      onLongPress: () => onLongPress!(),
      child: Container(
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
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
              customer,
              style: TextStyle(fontSize: size, fontWeight: fontWeight),
            ),
          ),
          Container(
            width: 100,
            child: Text(date,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 110,
            child: Text(remarks,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,
            child: Text(debit,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,
            child: Text(credit,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
          Container(
            width: 100,
            child: Text(total,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
            Container(
            width: textwidth,
            child: Text(attachment!,
                style: TextStyle(fontSize: size, fontWeight: fontWeight)),
          ),
             GestureDetector(
            onTap: () => onTab!(),
            child: Container(
              width: iconwidth,
              child: Icon(IconData),
            ),
          ),
        ]),
      ),
    );
  }

  textCont(String text, double size, {Color? color}) {
    return Text(
      '$text  ',
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
