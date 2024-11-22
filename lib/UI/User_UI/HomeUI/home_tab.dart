import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timtro/UI/User_UI/HomeUI/home_tab_body.dart';
import 'package:timtro/widgets/search.dart';


class HomeTab extends StatelessWidget {
  final CupertinoTabController tabController;

  HomeTab({required this.tabController});
  @override
  Widget build(BuildContext context) {

    print("current height: "+MediaQuery.of(context).size.height.toString());
    return SafeArea(
      child: Scaffold(
        body:  Column(
          children: [
            Container(
      
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 15),
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
      
                    Center(
                      child: Container(
      
                        child: SearchWidget(onSearch: (String ) {  },),
      
      
                      ),
                    )
                  ],
                ),
              ),
            ),
      
            Expanded( // Wrap HomeTabBody with Expanded for better space management
              child: SingleChildScrollView(
                child: HomeTabBody(tabController: tabController,),
              ),
            )
          ],
        ),
      ),
    );
  }

}
