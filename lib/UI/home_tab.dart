import 'package:flutter/material.dart';
import 'package:timtro/UI/home_tab_body.dart';

import '../utils/colors.dart';
import '../widgets/big_text.dart';
import '../widgets/small_text.dart';
import '../widgets/search.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Tìm phòng giá tốt tại đây'),
    //     backgroundColor: Colors.blue,
    //   ),
    //   body: Column(
    //     children: [
    //       Container(
    //         padding: EdgeInsets.all(10),
    //         color: Colors.blue,
    //         child: Column(
    //           children: [
    //             Text(
    //               'ỨNG DỤNG TÌM TRỌ DUY NHẤT HIỆN NAY',
    //               style: TextStyle(color: Colors.white),
    //             ),
    //             // Add more widgets here to complete the banner
    //           ],
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text(
    //           'Xu hướng tìm kiếm',
    //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       GridView.count(
    //         crossAxisCount: 4,
    //         shrinkWrap: true,
    //         children: [
    //           // Each button can be a Column containing an Icon and Text
    //           buildIconButton('Phòng trọ sinh viên', Icons.house),
    //           buildIconButton('Phòng trọ có gác', Icons.stairs),
    //           buildIconButton('Phòng trọ giá rẻ', Icons.attach_money),
    //           buildIconButton('Nuôi thú cưng', Icons.pets),
    //           buildIconButton('Có ban công', Icons.balcony),
    //           buildIconButton('Phòng trọ theo quận', Icons.location_on),
    //           buildIconButton('Căn hộ dịch vụ', Icons.hotel),
    //           buildIconButton('Cho người nước ngoài', Icons.people),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
    print("current height: "+MediaQuery.of(context).size.height.toString());
    return Scaffold(
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
              child: HomeTabBody(),
            ),
          )
        ],
      ),
    );
  }
  // Column buildIconButton(String text, IconData icon) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Icon(icon, size: 40, color: Colors.blue),
  //       SizedBox(height: 8),
  //       Text(text, textAlign: TextAlign.center),
  //     ],
  //   );
  // }

}
