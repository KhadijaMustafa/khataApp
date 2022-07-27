import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final Color? bordercolor;
  final TextInputType? keyboardtype;
  final TextEditingController? controller;
  final String? hinttext;
  final Color? hintcolor;
  final double? height;
  final double? width;
  final Color? bgcolor;
  final BoxBorder? border;
  final BorderRadius? borderradius;
  final Function(String)? onChanged;
  final IconData? prefixicon;
  final IconData? suffixicon;
  final Color? precolor;
  final Color? sufcolor;

  const TextFieldWidget(
      {Key? key,
      this.bgcolor,
      this.border,
      this.bordercolor,
      this.borderradius,
      this.controller,
      this.height,
      this.hintcolor,
      this.hinttext,
      this.keyboardtype,
      this.width,
      this.onChanged,this.precolor,this.prefixicon,this.sufcolor,this.suffixicon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
       padding: EdgeInsets.only(left: 20, right: 10),
      margin: EdgeInsets.only(left: 20, top: 25, right: 20),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: bordercolor!)),
      child: TextFormField(
        keyboardType: keyboardtype,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            // prefixIcon: Icon(
            //   prefixicon,
            //   color: precolor,
            // ),
            // suffixIcon: GestureDetector(
            //   onTap: () {},
            //   child: Icon(
            //     suffixicon,
            //     color: sufcolor,
            //   ),
            // ),
            hintText: '$hinttext',
            hintStyle: TextStyle(color: hintcolor, fontSize: 14),
            border: InputBorder.none),
        onChanged: (value) {
          onChanged!(value);
        },
      ),
    );
  }
}
