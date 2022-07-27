import 'package:flutter/material.dart';
class Test extends StatefulWidget {
  Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<String> expenseList = [
    'Usman',
    'Tayab',
    'Ali',
    
  ];
  List<String> expenseList2 = [
    'Usman',
    'Tayab',
    'Ali',
    
  ];
  List<String> expenseList3 = [
    'Usman',
    'Tayab',
    'Ali',
    
  ];
  List allList=[["expenseList"],["expenseList2"],["expenseList3"]];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(child: SingleChildScrollView(
        child: Column(
          children: [
          //Dashboard code 
             //       : category == 0 && indexColor == 1
                      //           ? Container(
                      //               decoration: BoxDecoration(
                      //                   //color: Color.fromARGB(255, 243, 245, 247),

                      //                   ),
                      //               margin:
                      //                   EdgeInsets.only(left: 30, right: 30),
                      //               child: GridView.builder(
                      //                 physics: NeverScrollableScrollPhysics(),
                      //                 gridDelegate:
                      //                     const SliverGridDelegateWithFixedCrossAxisCount(
                      //                         crossAxisCount: 2,
                      //                         childAspectRatio: 1.2,
                      //                         crossAxisSpacing: 3,
                      //                         mainAxisSpacing: 3),
                      //                 shrinkWrap: true,
                      //                 itemCount: vehList.length,
                      //                 itemBuilder:
                      //                     (BuildContext context, int index) {
                      //                   var color =
                      //                       vehList[index]['documentType'];
                      //                   var item = vehList[index];
                      //                   return listCont(
                      //                       '${item['expiredCount']}',
                      //                       '${item['documentType']}',
                      //                       IconData: FontAwesomeIcons.car,
                      //                       onTap: () {
                      //                     setState(() {
                      //                       selected = item;
                      //                     });
                      //                     MyNavigation().push(
                      //                         context,
                      //                         EmloyeeDocument(
                      //                             documentType: vehList[index]
                      //                                 ['documentType'],
                      //                             entityName: vehList[index]
                      //                                 ['entityName']));
                      //                   },
                      //                       bgcolor: selected == item
                      //                           ? MyColors.cardgreen
                      //                           : MyColors.cardwhite,
                      //                       textcolor: selected == item
                      //                           ? MyColors.cardtxtgreen
                      //                           : MyColors.cardtxtwhite);
                      //                 },
                      //               ),
                      //             )
                      //           : Container(
                      //               //color: Color.fromARGB(255, 243, 245, 247),
                      //               margin:
                      //                   EdgeInsets.only(left: 30, right: 30),
                      //               child: GridView.builder(
                      //                 physics: NeverScrollableScrollPhysics(),
                      //                 gridDelegate:
                      //                     const SliverGridDelegateWithFixedCrossAxisCount(
                      //                         crossAxisCount: 2,
                      //                         childAspectRatio: 1.2,
                      //                         crossAxisSpacing: 3,
                      //                         mainAxisSpacing: 3),
                      //                 shrinkWrap: true,
                      //                 itemCount: projectList.length,
                      //                 itemBuilder:
                      //                     (BuildContext context, int index) {
                      //                   var color =
                      //                       projectList[index]['documentType'];
                      //                       var item=projectList[index];
                      //                   return listCont(
                      //                       '${item['expiredCount']}',
                      //                       '${item['documentType']}',
                      //                       IconData: FontAwesomeIcons.file,
                      //                       onTap: () {
                      //                         setState(() {
                      //                           selected=item;
                      //                         });
                      //                     MyNavigation().push(
                      //                         context,
                      //                         ProjectDocuments(
                      //                             documentType:
                      //                                 projectList[index]
                      //                                     ['documentType'],
                      //                             entityName: projectList[index]
                      //                                 ['entityName']));
                      //                   },  bgcolor: selected == item
                      //                           ? MyColors.cardgreen
                      //                           : MyColors.cardwhite,
                      //                       textcolor: selected == item
                      //                           ? MyColors.cardtxtgreen
                      //                           : MyColors.cardtxtwhite);
                      //                 },
                      //               ),
                      //             ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      ////////////////////////////////////////////
                      // textCont('Vehicle Document(s)'),
                      // Container(
                      //   decoration: BoxDecoration(

                      //   ),
                      //   margin: EdgeInsets.only(left: 30, right: 30),
                      //   child: GridView.builder(
                      //     physics: NeverScrollableScrollPhysics(),
                      //     gridDelegate:
                      //         const SliverGridDelegateWithFixedCrossAxisCount(
                      //             crossAxisCount: 2,
                      //             childAspectRatio: 1.2,
                      //             crossAxisSpacing: 6,
                      //             mainAxisSpacing: 6),
                      //     shrinkWrap: true,
                      //     itemCount: vehList.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       var color = vehList[index]['documentType'];
                      //       var item=vehList[index];
                      //       return listCont('${item['expiredCount']}',
                      //           '${item['documentType']}',

                      //           IconData: FontAwesomeIcons.car, onTap: () {
                      //             setState(() {
                      //               selected=item;
                      //             });
                      //         MyNavigation().push(
                      //             context,
                      //             EmloyeeDocument(
                      //                 documentType: vehList[index]
                      //                     ['documentType'],
                      //                 entityName: vehList[index]
                      //                     ['entityName']));
                      //       },bgcolor: selected == item
                      //                       ? MyColors.cardgreen
                      //                       : MyColors.cardwhite,
                      //                   textcolor: selected == item
                      //                       ? MyColors.cardtxtgreen
                      //                       : MyColors.cardtxtwhite);
                      //     },
                      //   ),
                      // ),
                      //   SizedBox(
                      //     height: 20,
                      //   ),
                      //  // textCont('Project Document(s)', , textcolor)
                      //   Container(
                      //     margin: EdgeInsets.only(left: 30, right: 30),
                      //     child: GridView.builder(
                      //       physics: NeverScrollableScrollPhysics(),
                      //       gridDelegate:
                      //           const SliverGridDelegateWithFixedCrossAxisCount(
                      //               crossAxisCount: 2,
                      //               childAspectRatio: 1.2,
                      //               crossAxisSpacing: 6,
                      //               mainAxisSpacing: 6),
                      //       shrinkWrap: true,
                      //       itemCount: projectList.length,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         var item = projectList[index];
                      //         return listCont(
                      //             '${item['expiredCount']}',
                      //             '${item['documentType']}',

                      //             IconData: FontAwesomeIcons.file, onTap: () {
                      //               setState(() {

                      //                 selected=item;
                      //               });
                      //           MyNavigation().push(
                      //               context,
                      //               ProjectDocuments(
                      //                   documentType: projectList[index]
                      //                       ['documentType'],
                      //                   entityName: projectList[index]
                      //                       ['entityName']));
                      //         },bgcolor: selected == item
                      //                       ? MyColors.cardgreen
                      //                       : MyColors.cardwhite,
                      //                   textcolor: selected == item
                      //                       ? MyColors.cardtxtgreen
                      //                       : MyColors.cardtxtwhite);
                      //       },
                      //     ),
                      //   ),


                      //Dashboard tab
                        // Container(
                      //     margin:
                      //         EdgeInsets.only(left: 15, right: 15, bottom: 20),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         GestureDetector(
                      //             onTap: () => setState(() {
                      //                   indexColor = 0;
                      //                 }),
                      //             child: textCont(
                      //               'Employee ',
                      //               indexColor == 0
                      //                   ? MyColors.yellow
                      //                   : Color.fromRGBO(234, 239, 243, 1),
                      //               indexColor == 0
                      //                   ? Color.fromARGB(255, 243, 245, 247)
                      //                   : MyColors.black,
                      //             )),
                      //         GestureDetector(
                      //           onTap: () => setState(() {
                      //             indexColor = 1;
                      //           }),
                      //           child: textCont(
                      //               'Vehicle ',
                      //               indexColor == 1
                      //                   ? MyColors.yellow
                      //                   : Color.fromRGBO(234, 239, 243, 1),
                      //               indexColor == 1
                      //                   ? Color.fromARGB(255, 243, 245, 247)
                      //                   : MyColors.black),
                      //         ),
                      //         GestureDetector(
                      //           onTap: () => setState(() {
                      //             indexColor = 2;
                      //           }),
                      //           child: textCont(
                      //               'Project ',
                      //               indexColor == 2
                      //                   ? MyColors.yellow
                      //                   : Color.fromRGBO(234, 239, 243, 1),
                      //               indexColor == 2
                      //                   ? Color.fromARGB(255, 243, 245, 247)
                      //                   : Color.fromRGBO(59, 66, 73, 1)),
                      //         ),
                      //       ],
                      //     )),

                      //  textCont('Employee Document(s)'),

          ],
        ),
      ),),
    );
  }
}