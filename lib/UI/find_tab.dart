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

import 'package:flutter/material.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/big_text.dart';
import 'package:timtro/widgets/small_text.dart';

import '../widgets/icon_and_text_widget.dart';
import '../widgets/search.dart';
// import 'package:http/http.dart' as http;

class FindTab extends StatefulWidget {
  @override
  _FindTabState createState() => _FindTabState();
}

class _FindTabState extends State<FindTab> {
  List<SearchResult> _searchResults = [];

  Future<void> _search(String query) async {
    // Gọi API tìm kiếm ở đây, ví dụ:
    var url = Uri.parse('https://api.example.com/search?query=$query');
    // var response = await http.get(url);
    // Parse kết quả và cập nhật _searchResults
  }

  @override
  Widget build(BuildContext context) {
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
                            _search(query); // Gọi hàm tìm kiếm khi người dùng nhập
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
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(left: 20, right: 20,bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white38,
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/anh1.png"),
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
                                            BigText(text: "Nhà trọ Ngọc Hân"),
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
                            );
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
