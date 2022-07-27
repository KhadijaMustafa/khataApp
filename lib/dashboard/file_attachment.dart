import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';

class FileAttachment extends StatefulWidget {
  String? image;
  FileAttachment({Key? key, this.image}) : super(key: key);

  @override
  State<FileAttachment> createState() => _FileAttachmentState();
}

class _FileAttachmentState extends State<FileAttachment> {
  var url = '';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.title,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Center(
              child: Container(
                // decoration: BoxDecoration(
                //   color: MyColors.grey,
                //    // border: Border.all(width: 5, color: MyColors.title),
                //     borderRadius: BorderRadius.circular(20)),
                height: height - 150,
                width: width - 50,
                margin: EdgeInsets.symmetric(
                  vertical: 30,
                ),
                padding: EdgeInsets.all(5),
                child: Image.network(
                  'https://fleet.xtremessoft.com/UploadFile/' +
                      '${widget.image}',
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
