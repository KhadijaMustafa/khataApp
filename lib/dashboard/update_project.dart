import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/project_list.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';

class UpdateProject extends StatefulWidget {
  final item;
  UpdateProject({Key? key, this.item}) : super(key: key);

  @override
  State<UpdateProject> createState() => _UpdateProjectState();
}

class _UpdateProjectState extends State<UpdateProject> {
  OneContext _context = OneContext.instance;

  TextEditingController codeController = TextEditingController();
  TextEditingController nameEngController = TextEditingController();
  TextEditingController nameUrduController = TextEditingController();
  TextEditingController tripController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  DateTime? dateFrom;
  DateTime? dateTo;

  var customer;
  var tosite;
  var fromsite;

  bool code = false;
  bool name = false;
  bool nameurd = false;
  bool trip = false;
  bool rate = false;
  bool fdate = false;
  bool tdate = false;
  bool custo = false;
  bool fsite = false;
  bool tsite = false;
  List customerDropdown = [];
  List siteDropdown = [];
  List projectList = [];
  List tositedropdown = [];
  getDropDownValues(String valueType) async {
    try {
      var response = await http.post(
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            "type": "$valueType",
            "value": {"Language": "en-US"}
          }));
      print(response.body);
      print(response.statusCode);

      var decode = json.decode(response.body);
      projectList = json.decode(decode['Value']);

      print(projectList);

      setState(() {});

      return projectList;
    } catch (e) {
      print(e);
    }
    ;
  }

  getListCall() async {
    customerDropdown = await getDropDownValues('Customer_DropdownList_Get');
    siteDropdown = await getDropDownValues('Site_DropdownList_GetByCustomerId');
  }

  updateProject() async {
    FocusManager.instance.primaryFocus?.unfocus();
    print('starttttt..................');
    if (codeController.text.isEmpty) {
      setState(() {
        code = true;
      });
    } else if (nameEngController.text.isEmpty) {
      setState(() {
        name = true;
      });
    } else if (nameUrduController.text.isEmpty) {
      setState(() {
        nameurd = true;
      });
    } else if (customer == null) {
      setState(() {
        custo = true;
      });
    } else if (fromsite == null) {
      setState(() {
        fsite = true;
      });
    } else if (tosite == null) {
      setState(() {
        tosite = true;
      });
    } else if (dateFrom == null) {
      setState(() {
        fdate = true;
      });
    } else if (dateTo == null) {
      setState(() {
        tdate = true;
      });
    } else if (tripController.text.isEmpty) {
      setState(() {
        trip = true;
      });
    } else if (rateController.text.isEmpty) {
      setState(() {
        rate = true;
      });
    } else {
      Map<String, String> body = {
        'type': 'Project_Save',
        'Id': '${widget.item['id']}',
        'Code': codeController.text,
        'NameEng': nameEngController.text,
        'NameUrd': nameUrduController.text,
        'StartDate': CusDateFormat.getDate(dateFrom!),
        'EndDate': CusDateFormat.getDate(dateTo!),
        'CustomerId': customer['value'],
        'FromSiteId': fromsite['value'],
        'ToSiteId': tosite['value'],
        'TotalTrips': tripController.text,
        'TripRate': rateController.text,
        'Language': 'en-US'
      };
      print(body);
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll(body);

        _context.showProgressIndicator(
            circularProgressIndicatorColor: Color.fromARGB(255, 98, 61, 12));
        http.StreamedResponse streamResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamResponse);
        _context.hideProgressIndicator();
        print('object');
        if (response.statusCode == 200) {
          print('object');

          var decode = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully updated.'),
          ));
          Navigator.pop(context);
          var route = MaterialPageRoute(
            builder: (context) => ProjectList(),
          );
          Navigator.pushReplacement(context, route);
          print(decode);
          print('decode');
        }
      } catch (e) {
        _context.hideProgressIndicator();
        print(e);
      }
    }
  }

  @override
  void initState() {
    print('object');
    print('object');
    print('object');

    print(widget.item['code']);
    print(widget.item['name']);
    print(widget.item['customerId']);
    print(widget.item['customerName']);

    print('object');

    getListCall();
    codeController.text = widget.item['code'];
    nameEngController.text = widget.item['name'];
    nameUrduController.text = widget.item!['name'];

    customer = {
      'value': widget.item['customerId'],
      'text': widget.item['customerName']
    };
    fromsite = {
      'value': widget.item['fromSiteId'],
      'text': widget.item['fromSite']
    };
    tosite = {
      'value': widget.item['toSiteId'],
      'text': widget.item['toSite']
    };

    dateFrom = DateTime.parse(widget.item['startDate']);
    dateTo = DateTime.parse(widget.item['endDate']);
    tripController.text = widget.item['totalTrips'].toString();
    rateController.text = widget.item['tripRate'].toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          'Add Project',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            textFieldCont(
              'Code',
              codeController,
              code ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  code = false;
                });
              },
            ),
            code ? validationCont() : Container(),
            textFieldCont(
              'Name (English)',
              nameEngController,
              name ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  name = false;
                });
              },
            ),
            name ? validationCont() : Container(),
            textFieldCont(
              'Name (Urdu)',
              nameUrduController,
              nameurd ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  nameurd = false;
                });
              },
            ),
            nameurd ? validationCont() : Container(),
            dropdownComp(
                customer == null ? "Customer" : customer["text"],
                custo ? Colors.red : Colors.black, onchanged: (value) {
              setState(() {
                customer = value;
                custo = false;
              });
            }, list: customerDropdown, dropdowntext: "text"),
            custo ? validationCont() : Container(),
            dropdownComp(
                fromsite == null ? "From Site" : fromsite["text"],
                fsite ? Colors.red : Colors.black, onchanged: (value) {
              setState(() {
                fromsite = value;
                fsite = false;
              });
            }, list: siteDropdown, dropdowntext: "text"),
            fsite ? validationCont() : Container(),
            dropdownComp(
                tosite == null ? "To Site" : tosite["text"],
                tsite ? Colors.red : Colors.black, onchanged: (value) {
              setState(() {
                tosite = value;
                tsite = false;
              });
            }, list: siteDropdown, dropdowntext: "text"),
            tsite ? validationCont() : Container(),
            dateCont(
                fdate ? Colors.red : Colors.black,
                dateFrom == null
                    ? 'Start Date'
                    : '${CusDateFormat.getDate(dateFrom!)}',
                (date) => setState(() {
                      dateFrom = date;

                      fdate = false;
                    })),
            dateCont(
                tdate ? Colors.red : Colors.black,
                dateTo == null
                    ? 'End Date'
                    : '${CusDateFormat.getDate(dateTo!)}',
                (date) => setState(() {
                      dateTo = date;

                      fdate = false;
                    })),
            textFieldCont(
              'Total Trips',
              tripController,
              trip ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  trip = false;
                });
              },
            ),
            trip ? validationCont() : Container(),
            textFieldCont(
              'Trip Rate',
              rateController,
              rate ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  rate = false;
                });
              },
            ),
            rate ? validationCont() : Container(),
            InkWell(
              onTap: () {
                updateProject();
              },
              child: Container(
                height: 50,
                margin:
                    EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 30),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MyColors.yellow,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: MyColors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  dropdownComp(String hinttext, Color bordercolor,
      {Function? onchanged, List? list, String? dropdowntext}) {
    return Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: bordercolor,
            )),
        margin: EdgeInsets.only(left: 20, top: 25, right: 20),
        child: DropdownButtonFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          isExpanded: true,
          decoration: InputDecoration(
              border: InputBorder.none,
              filled: false,
              hintStyle: TextStyle(color: MyColors.black),
              hintText: '$hinttext',
              fillColor: Colors.white),
          onChanged: (value) => onchanged!(value),
          items: list
              ?.map((item) => DropdownMenuItem(
                  value: item, child: Text("${item[dropdowntext]}")))
              .toList(),
        ));
  }

  validationCont() {
    return Container(
      margin: EdgeInsets.only(left: 35),
      alignment: Alignment.topLeft,
      height: 15,
      child: Text(
        'This field is required',
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  textFieldCont(String hint, TextEditingController controller, Color,
      {Function(String)? onChanged, TextInputType? keyboard}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Color)),
      child: TextFormField(
        keyboardType: keyboard,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: MyColors.black, fontSize: 14),
            border: InputBorder.none),
        onChanged: (value) => onChanged!(value),
      ),
    );
  }

  dateCont(Color bordercolor, String text, Function(DateTime) pickedDate) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: bordercolor)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //child: Text('day-mon-year'),
            child: Text(text),
          ),
          InkWell(
            onTap: () async {
              DateTime? date = await showDatePicker(
                  context: context,
                  fieldHintText: 'day-mon-year',
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025));
              if (date != null) {
                pickedDate(date);

                print(date);
              }
            },
            child: Container(
              child: Icon(Icons.calendar_today),
            ),
          )
        ],
      ),
    );
  }
}
