import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
class DeleteFunction extends StatelessWidget {
  final Function? deleteF;
  const DeleteFunction({Key? key,this.deleteF}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child:  GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //title: Text('data'),
                                  content: Text(
                                    'Delete this record?',
                                    style: TextStyle(
                                        color: MyColors.yellow,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                         
                                            deleteF;
                                         
                                        },
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ],
                                );
                              });
                        },
                        child: actionIcon(
                          Icons.delete,
                        )),
    );
  }
    actionIcon(IconData) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      child: Icon(
        IconData,
        color: Colors.black,
        size: 25,
      ),
    );
  }
}