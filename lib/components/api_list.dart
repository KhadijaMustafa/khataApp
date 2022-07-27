import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
class ApiList extends StatelessWidget {
  final String? type;
  final List? mainList;
  final bool? loading;
  const ApiList({Key? key,this.type,this.mainList,this.loading}) : super(key: key);
  getVehicleList() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST',
          Uri.parse('https://fleet.xtremessoft.com/services/Xtreme/process'));
      request.body = json.encode({
         "type": "$type",
  "value": {
    "Language": "en-US",
    "Id": "9eb1b314-64d7-ec11-9168-00155d12d305"
  }
      });

      request.headers.addAll(headers);
      http.StreamedResponse streamResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        var decode = json.decode(response.body);
        print('Successssssssssssssss');
        print(decode['Value']);
        print(response.body);
        return json.decode(decode['Value']);
      }
    } catch (e) {
      print(e);
    }
  }

  // getApiCall() async{
  //   mainList!=await getVehicleList();
  //   loading;


  // }

 

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}