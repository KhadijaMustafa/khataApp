import 'package:flutter/material.dart';
class TextWidget extends StatelessWidget {
  final String? text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? textcolor;
  const TextWidget({Key? key,this.size,this.text,this.fontWeight,this.textcolor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('$text',style: TextStyle(color: textcolor,fontSize: size,fontWeight: fontWeight),),
    );
  }
}