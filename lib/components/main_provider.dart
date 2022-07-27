

import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
class MainProvider extends ChangeNotifier{
  bool _ischeck=false;
  bool get check=>_ischeck;
  checkbox(bool value){
    _ischeck=!value;
    notifyListeners();
  }
  String? _fieldvalue;
  String? get fieldvalue=>_fieldvalue;
  textfield(String value){
    _fieldvalue=value;
    notifyListeners();
  }

  var driver;

  bool? _drivername;
  bool? get drivername=>_drivername;
     dropdown (value) {
                    driver = value;
                  _drivername = false;
                  print(driver);
                  print('driver');

            
              }
   bool? setdate;  
   BuildContext? context;         
  DateTime selectedDate = DateTime.now();
  getDate() async {
                        DateTime? date = await showDatePicker(
                            context: context!,
                            fieldHintText: 'day-mon-year',
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2025));

                        if (date != null) {
                        
                            selectedDate = date;
                            setdate = false;
                        
                         print(date);
                          print(CusDateFormat.getDate(date));
                          notifyListeners();
                       }
                      }
 
}