import 'package:flutter/material.dart';

class MyNavigation {
  push(BuildContext context, Widget screen) {
    var route = MaterialPageRoute(builder: (context) => screen);
    Navigator.push(context, route);
  }

  static pushstatic(BuildContext context, Widget screen) {
    var route = MaterialPageRoute(builder: (context) => screen);
    Navigator.push(context, route);
  }

  pushRemove(BuildContext context, Widget screen) {
    var newRoute = MaterialPageRoute(builder: (context) => screen);
    Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
  }
}
