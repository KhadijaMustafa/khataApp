import 'package:flutter/material.dart';
import 'package:xtreme_fleet/components/checkbox_widget.dart';
import 'package:xtreme_fleet/components/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
class CheckButton extends StatelessWidget {
  const CheckButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainProvider provider=Provider.of(context,listen: false);

    return Consumer<MainProvider>(
      builder: (context,prov,child) {
        return CheckboxWidget(bordercolor: MyColors.bggreen,iconcolor: MyColors.orange,ischecked: prov.check ,onTab: (value)=>provider.checkbox(value),);
      }               
    );
  }
}