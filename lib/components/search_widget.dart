import 'package:flutter/material.dart';
import 'package:xtreme_fleet/utilities/my_colors.dart';
class SearchWidget extends StatelessWidget {
  final TextEditingController? searchController;
  final bool? isSearching;
  final List? mainListp;
  final Function? searchItem;
  
  final Color? iconcolor;
  final double? size;
  const SearchWidget({Key? key,this.searchController,this.isSearching,this.mainListp,this.searchItem,this.iconcolor,this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Container(
                      height: 45,
                      padding: EdgeInsets.only(
                          left: 20, top: 4, bottom: 4, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: MyColors.grey)),
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: TextFormField(
                        cursorColor: MyColors.black,
                        controller: searchController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search here .........',
                            suffixIcon: GestureDetector(
                              onTap: () => searchItem,
                             
                                child: Icon(
                                  Icons.search,
                                  size: size,
                                  color: iconcolor,
                                ))),
                      ),
                    ),
    );
  }
}