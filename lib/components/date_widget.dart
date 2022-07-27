import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/CusDateFormat.dart';
class DateWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final Color? bordercolor;
final bool? setdate;
  final Function(DateTime)? pickedDate;
  const DateWidget({Key? key,this.selectedDate,this.bordercolor,this.pickedDate,this.setdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
                margin: EdgeInsets.only(left: 20, top: 25, right: 20),
                padding: EdgeInsets.only(left: 20, right: 10),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: bordercolor!)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //child: Text('day-mon-year'),
                      child: Text('${CusDateFormat.getDate(selectedDate!)}'),
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
                          pickedDate;
                          // setState(() {
                          //   selectedDate = date;
                          //   setdate = setdate;
                          // });
                          print(date);
                          print(CusDateFormat.getDate(date));
                       } },
                      child: Container(
                        child: Icon(Icons.calendar_today),
                      ),
                    )
                  ],
                ),
              );
  }
}