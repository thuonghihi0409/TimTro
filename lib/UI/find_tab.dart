// import 'package:flutter/material.dart';
//
// class FindTab extends StatelessWidget {
//   const FindTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("Find tab"),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/UI/room_detail_page.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/big_text.dart';
import 'package:timtro/widgets/small_text.dart';
import 'package:http/http.dart' as http;
import 'package:timtro/utils/dimensions.dart';
import '../widgets/icon_and_text_widget.dart';
import '../widgets/search.dart';
// import 'package:http/http.dart' as http;

class FindTab extends StatefulWidget {
  @override
  _FindTabState createState() => _FindTabState();
}

class _FindTabState extends State<FindTab> {


  @override
  Widget build(BuildContext context) {
    final rentalpropertycontroller = context.watch<Rentalpropertycontroller>();
    return Scaffold(

      body: Column(
        children: [
          Container(

            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        child: SearchWidget(
                          onSearch: (query) {
                            rentalpropertycontroller.setRental(); // Gọi hàm tìm kiếm khi người dùng nhập
                          },

                        ),

                      ),
                    )

                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: _searchResults.length,
                    //     itemBuilder: (context, index) {
                    //       return ListTile(
                    //         title: Text(_searchResults[index].title),
                    //         subtitle: Text(_searchResults[index].description),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ]

              ),

            )
          ),
          Expanded(
            child: Container(
              height: 600,
              // margin: EdgeInsets.only(top: 10),
              child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.only(left: 30, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          BigText(text: "Phổ biến"),
                          SizedBox(width: 10,),
                          Container(
                            margin: const EdgeInsets.only(bottom: 3),
                            child: BigText(text: ".", color: Colors.black26,),
                          ),
                          SizedBox(width: 10,),
                          Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: SmallText(text:"được xem nhiều nhất")
                          )
                        ],
                      ),
                    ),
                    //list
                    // Container(
                    //   height: 600,
                    //   child: ListView.builder(
                    //       itemCount: 10,
                    //       itemBuilder: (context, index){
                    //         return Container(
                    //           margin: EdgeInsets.only(left: 20, right: 20),
                    //           child: Row(
                    //             children: [
                    //               Container(
                    //                 width: 120,
                    //                 height: 120,
                    //                 decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(20),
                    //                     color: Colors.white38,
                    //                     image: DecorationImage(
                    //                         image: AssetImage(
                    //                             "assets/images/anh1.png"
                    //                         ))
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         );
                    //       }),
                    // )
            
            
                    Expanded(
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: rentalpropertycontroller.listRental.length, // Số lượng item trong danh sách
                          itemBuilder: (context, index) {
                            final toElement = rentalpropertycontroller.listRental[index]; // Lấy phần tử dựa trên index
                            return Item(rentalProperty: toElement,); // Trả về widget Item
                          },
                        ),
                      ),
            
            
                  ]
            
              ),
            ),
          ),

        ],
      ),

    );
  }
}


class Item extends StatelessWidget {
  RentalProperty rentalProperty;

  Item({super.key, required this.rentalProperty});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20,bottom: 10),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white38,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Đảm bảo ảnh cũng có góc bo tròn
                child: Image.network(
                  '${rentalProperty.image}', // Thay thế bằng URL của ảnh bạn muốn
                  fit: BoxFit.cover, // Điều chỉnh cách hiển thị ảnh
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Center(child: Text('Error loading image')); // Hiển thị thông báo khi có lỗi
                  },
                ),
              ),
            ),



            Expanded(
              child: Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BigText(text: "${rentalProperty.propertyName}"),
                      SizedBox(height: 10,),
                      SmallText(text: "Dành cho nữ"),
                      SizedBox(height: 10,),
                      Row(
                        //can chinh deu 3 icon
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconAndTextWidget(icon: Icons.star,
                            text: "4.5",
                            iconColor: AppColors.inconColor1,),
                          IconAndTextWidget(icon: Icons.location_on,
                            text: "1.7km",
                            iconColor: AppColors.mainColor,),
                          IconAndTextWidget(icon: Icons.access_time_rounded,
                            text: "32min",
                            iconColor: AppColors.inconColor2,)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: (){
        // Gọi trang mới khi nhấn vào InkWell
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RoomDetailPage()),
        );
      },
    );
  }
}



class SearchResult {
  final String title;
  final String description;
  final String url;

  SearchResult({
    required this.title,
    required this.description,
    required this.url,
  });
}
