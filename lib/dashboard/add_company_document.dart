import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:xtreme_fleet/dashboard/company_document.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
import 'package:xtreme_fleet/utilities/pickers.dart';

class AddCompanyDocument extends StatefulWidget {
   final items;
   final title;
  AddCompanyDocument({Key? key,this.items,this.title}) : super(key: key);

  @override
  State<AddCompanyDocument> createState() => _AddCompanyDocumentState();
}

class _AddCompanyDocumentState extends State<AddCompanyDocument> {
  TextEditingController nameEngController = TextEditingController();
  TextEditingController nameUrdController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController descriptionUrdController = TextEditingController();
  OneContext _context = OneContext.instance;
String? currentImage;
  DateTime? issueDate;
  DateTime? expiryDate;
  bool name = false;
  bool nameurd = false;
  bool description = false;
  bool descriptionurd = false;
  bool idate = false;
  bool expDate = false;
bool file=false;
  bool _expiry = false;
  bool get expiry => _expiry;
  checkbox(bool value) {
    print(value);
    _expiry = value;
    setState(() {});
  }

  String? imageFile;
  pickImageFomG(ImageSource source) async {
    XFile? file = await Pickers.instance.pickImage(source: source);
    if (file != null) {
      imageFile = file.path;
      setState(() {});
    }
  }

  addDocument()async{
    FocusManager.instance.primaryFocus?.unfocus();
    if (imageFile == null && currentImage==null) {
      setState(() {
        file = true;
      });
    }
     else
     if(nameEngController.text.isEmpty){
      setState(() {
        name=true;
      });
    } else if(nameUrdController.text.isEmpty){
      setState(() {
        nameurd=true;
      });
    } else if(issueDate==null){
      setState(() {
        idate=true;
      });
    } 
    else if(expiryDate==null && _expiry==false){
      setState(() {
        expDate=true;
      });
    }
     else if(descriptionController.text.isEmpty){
      setState(() {
        description=true;
      });
    } else if(descriptionUrdController.text.isEmpty){
      setState(() {
        descriptionurd=true;
      });
    } else{
    Map<String, String> body= {
          'type': 'CompanyDocument_Save',
          'Id':widget.title=='Update Company Document'? '${widget.items['id']}': '00000000-0000-0000-0000-000000000000',
          'UserId': 'f14198a1-1a9a-ec11-8327-74867ad401de',
          "NameEng": nameEngController.text,
          "NameUrd": nameUrdController.text,
           "DescriptionEng": descriptionController.text,
          "DescriptionUrd": descriptionUrdController.text,
          "IssueDate": CusDateFormat.getDate(issueDate!),
          "ExpiryDate":_expiry? 'year-month-day': CusDateFormat.getDate(expiryDate!),
          'Language': 'en-US'
        } ;
        print(body);
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://fleet.xtremessoft.com/services/Xtreme/multipart'));
        request.fields.addAll(body);
        if (imageFile != null) {
          request.files.add(
              await http.MultipartFile.fromPath('Attachment', '$imageFile'));
        }
        _context.showProgressIndicator(
            circularProgressIndicatorColor: Color.fromARGB(255, 98, 61, 12));
        http.StreamedResponse streamResponse = await request.send();
        http.Response response = await http.Response.fromStream(streamResponse);
        _context.hideProgressIndicator();

        print('false');
      
        if (response.statusCode == 200) {
          var decode = json.decode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: MyColors.bggreen,
            content: Text('Record succesfully added.'),
          ));
          Navigator.pop(context);
          var route = MaterialPageRoute(
            builder: (context) => CompanyDocument(),
          );
          Navigator.pushReplacement(context, route);
          print(decode);
          return decode;
        } else {
          print('falseeeeeeeeeeeeeeeeeeee');
          print(response.reasonPhrase);
        }
      } catch (e) {
        print(e);
      }

    }
      
  }
  @override
  void initState() {
    if(widget.title=='Update Company Document'){
        nameEngController.text=widget.items['nameEng'];
  nameUrdController.text=widget.items['nameUrd'];
  descriptionController.text=widget.items['descriptionEng'];
  descriptionUrdController.text=widget.items['descriptionUrd'];
  issueDate= DateTime.parse(widget.items['issueDate']) ;
if(expiryDate != null){
  
  expiryDate= DateTime.parse(widget.items['expiryDate']);


}else{_expiry=true;}
// if (imageFile != null) {
     currentImage = widget.items['currentFileName'];
  // }

    }


 // expiryDate=widget.items['expiryDate'];

    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.yellow,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 25, right: 20),
              padding: EdgeInsets.only(left: 20, right: 10),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color:file?Colors.red: Colors.black)),
              child: Row(
                children: [
                  Container(
                    height: 25,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(1)),
                    child: InkWell(
                        onTap: () {
                          pickImageFomG(ImageSource.gallery);
                          setState(() {
                            file = false;
                          });
                        },
                        child:
                            Text('Choose Doc', style: TextStyle(fontSize: 11))),
                  ),
                  imageFile != null ||currentImage!=null
                      ? Expanded(
                          child: Container(
                            height: 20,
                            child: Text(
                              imageFile?.split('/').last??currentImage??"",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        )
                      : Text('No file choosen')
                ],
              ),
            ),
            file ? validationCont() : Container(),


            textFieldCont(
              50,
              'Name (English)',
              nameEngController,
              name ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  name = false;
                });
              },colps: false,
            ),
            name ? validationCont() : Container(),
            textFieldCont(
              50,
              'Name (Urdu)',
              nameUrdController,
              nameurd ? Colors.red : Colors.black,
              onChanged: (value) {
                setState(() {
                  nameurd = false;
                });
              },colps: false,
            ),
            nameurd ? validationCont() : Container(),
            dateCont(
                idate ? Colors.red : Colors.black,
                issueDate == null
                    ? 'Issue Date'
                    : '${CusDateFormat.getDate(issueDate!)}',
                (date) => setState(() {
                      issueDate = date;

                      idate = false;
                    })),
            dateCont(
                expDate && _expiry==false ? Colors.red : Colors.black,
                expiryDate == null ||_expiry
                    ? 'Expiry Date'
                    : '${CusDateFormat.getDate(expiryDate!)}',
                (date) => setState(() {
                  _expiry? expiryDate=null:
                      expiryDate = date;

                      expDate = false;
                    }),bg: _expiry?MyColors.grey:Colors.transparent),
            Container(
              margin: EdgeInsets.only(left: 20, top: 25),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Text(
                      'No Expiry',
                      style: TextStyle(color: MyColors.black),
                    ),
                  ),
                  checkboxCont(expiry, onTab: (value) => checkbox(value)),
                ],
              ),
            ),
            textFieldCont(70, 'Description (English)', descriptionController,
                description ? Colors.red : Colors.black, onChanged: (value) {
              setState(() {
                description = false;
              });
            }, maxline: null, colps: true, keyboard: TextInputType.multiline),
            description ? validationCont() : Container(),
            textFieldCont(70, 'Description (Urdu)', descriptionUrdController,
                descriptionurd ? Colors.red : Colors.black, onChanged: (value) {
              setState(() {
                descriptionurd = false;
              });
            }, maxline: null, colps: true, keyboard: TextInputType.multiline),
            descriptionurd ? validationCont() : Container(),
            InkWell(
              onTap: () {
                addDocument();

              },
              
              child: Container(
                height: 50,
                margin:
                    EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 20),
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

  textFieldCont(
      double height, String hint, TextEditingController controller, Color,
      {Function(String)? onChanged,
      TextInputType? keyboard,
      int? maxline,
      bool? colps, }) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10,top: 5),
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      height: height,
      decoration: BoxDecoration(
     
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Color)),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLines: maxline,
        keyboardType: keyboard,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            isCollapsed: colps!,
            hintText: hint,
            hintStyle: TextStyle(color: MyColors.black, fontSize: 14),
            border: InputBorder.none),
        onChanged: (value) => onChanged!(value),
      ),
    );
  }

  dateCont(Color bordercolor, String text, Function(DateTime) pickedDate,{Color? bg}) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 50,
      decoration: BoxDecoration(
        color: bg,
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

  checkboxCont(bool ischecked, {Function(bool)? onTab}) {
    return GestureDetector(
      onTap: () => onTab!(!ischecked),
      child: Stack(alignment: Alignment.center, children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: MyColors.black)),
          height: 20,
          width: 18,
        ),
        Container(
          height: 25,
          width: 25,
        ),
        if (ischecked)
          Icon(
            Icons.check,
            color: MyColors.yellow,
          )
      ]),
    );
  }
}
