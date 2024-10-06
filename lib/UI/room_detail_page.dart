// // import 'package:flutter/material.dart';
// //
// // import '../utils/colors.dart';
// //
// // class RoomDetailPage extends StatelessWidget {
// //   final List<String> productImages = [
// //     'assets/images/anh1.png',
// //     'assets/images/anh2.png',
// //     'assets/images/anh4.png',
// //     'assets/images/anh4.png',
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Chi tiết phòng'),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Hiển thị hình ảnh sản phẩm
// //               Container(
// //                 height: 300, // Chiều cao của khu vực hình ảnh
// //                 child: PageView.builder(
// //                   itemCount: productImages.length,
// //                   itemBuilder: (context, index) {
// //                     return Image.asset(
// //                       productImages[index],
// //                       fit: BoxFit.cover,
// //                     );
// //                   },
// //                 ),
// //               ),
// //               Text(
// //                 'Phòng thường - Lầu 2 - Máy lạnh',
// //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //               ),
// //               Text(
// //                 'Giá: 4,000,000 VNĐ',
// //                 style: TextStyle(fontSize: 18),
// //               ),
// //               Text(
// //                 'Địa chỉ: 87/xx/xx Nguyễn Sỹ Sách, Phường 15, Quận Tân Bình, Thành phố Hồ Chí Minh',
// //               ),
// //               Text('Thời gian: Tự do'),
// //               SizedBox(height: 20),
// //               // Bảng giá
// //               Table(
// //                 border: TableBorder.all(),
// //                 children: [
// //                   TableRow(children: [
// //                     Text('Điện'),
// //                     Text('Nước'),
// //                     Text('Xe'),
// //                     Text('Quản lý'),
// //                   ]),
// //                   TableRow(children: [
// //                     Text('3.800/kWh'),
// //                     Text('80.000/ng'),
// //                     Text('80.000/xe'),
// //                     Text('0/ph'),
// //                   ]),
// //                   // ... các hàng còn lại
// //                 ],
// //               ),
// //               SizedBox(height: 20),
// //               // Nút
// //               Container(
// //                 margin: EdgeInsets.only(top: 100),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                   children: [
// //                     ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                           backgroundColor: AppColors.mainColor, // Màu nền
// //                           foregroundColor: Colors.white, // Màu chữ
// //                       ),
// //                       onPressed: () {},
// //                       child: Text('   Đặt lịch\nxem phòng',
// //                         style: TextStyle(
// //                           color: Colors.black
// //                         ),
// //                       ),
// //                     ),
// //                     ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: AppColors.mainColor, // Màu nền
// //                         foregroundColor: Colors.white, // Màu chữ
// //                       ),
// //                       onPressed: () {},
// //                       child: Text('Chat\nngay',
// //                         style: TextStyle(
// //                             color: Colors.black
// //                         ),
// //                       ),
// //                     ),
// //                     ElevatedButton(
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: AppColors.mainColor, // Màu nền
// //                         foregroundColor: Colors.white, // Màu chữ
// //                       ),
// //                       onPressed: () {},
// //                       child: Text('Gọi điện',
// //                         style: TextStyle(
// //                             color: Colors.black
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import '../utils/colors.dart';
//
// class RoomDetailPage extends StatefulWidget {
//   @override
//   _RoomDetailPageState createState() => _RoomDetailPageState();
// }
//
// class _RoomDetailPageState extends State<RoomDetailPage> {
//   final List<String> productImages = [
//     'assets/images/anh1.png',
//     'assets/images/anh2.png',
//     'assets/images/anh4.png',
//     'assets/images/anh4.png',
//   ];
//
//   // PageController để điều khiển chuyển trang
//   PageController _pageController = PageController();
//   int _currentPage = 0; // Theo dõi trang hiện tại
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chi tiết phòng'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Hiển thị hình ảnh sản phẩm
//               Stack(
//                 children: [
//                   Container(
//                     height: 300, // Chiều cao của khu vực hình ảnh
//                     child: PageView.builder(
//                       controller: _pageController,
//                       itemCount: productImages.length,
//                       onPageChanged: (index) {
//                         setState(() {
//                           _currentPage = index; // Cập nhật số trang hiện tại
//                         });
//                       },
//                       itemBuilder: (context, index) {
//                         return Image.asset(
//                           productImages[index],
//                           fit: BoxFit.cover,
//                         );
//                       },
//                     ),
//                   ),
//                   // Hiển thị số đếm trên hình ảnh (ví dụ: 1/4, 2/4,...)
//                   Positioned(
//                     bottom: 10,
//                     right: 10,
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       color: Colors.black54,
//                       child: Text(
//                         '${_currentPage + 1}/${productImages.length}', // Ví dụ: 1/4
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Mũi tên sang trái
//                   Positioned(
//                     left: 0,
//                     top: 0,
//                     bottom: 0,
//                     child: IconButton(
//                       icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//                       onPressed: () {
//                         if (_currentPage > 0) {
//                           _pageController.previousPage(
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   // Mũi tên sang phải
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     bottom: 0,
//                     child: IconButton(
//                       icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
//                       onPressed: () {
//                         if (_currentPage < productImages.length - 1) {
//                           _pageController.nextPage(
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Phòng thường - Lầu 2 - Máy lạnh',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 'Giá: 4,000,000 VNĐ',
//                 style: TextStyle(fontSize: 18),
//               ),
//               Text(
//                 'Địa chỉ: 87/xx/xx Nguyễn Sỹ Sách, Phường 15, Quận Tân Bình, Thành phố Hồ Chí Minh',
//               ),
//               Text('Thời gian: Tự do'),
//               SizedBox(height: 20),
//               // Bảng giá
//               Table(
//                 border: TableBorder.all(),
//                 children: [
//                   TableRow(children: [
//                     Text('Điện'),
//                     Text('Nước'),
//                     Text('Xe'),
//                     Text('Quản lý'),
//                   ]),
//                   TableRow(children: [
//                     Text('3.800/kWh'),
//                     Text('80.000/ng'),
//                     Text('80.000/xe'),
//                     Text('0/ph'),
//                   ]),
//                 ],
//               ),
//               SizedBox(height: 20),
//               // Nút
//               Container(
//                 margin: EdgeInsets.only(top: 80),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.mainColor, // Màu nền
//                         foregroundColor: Colors.white, // Màu chữ
//                       ),
//                       onPressed: () {},
//                       child: Text(
//                         '   Đặt lịch\nxem phòng',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.mainColor, // Màu nền
//                         foregroundColor: Colors.white, // Màu chữ
//                       ),
//                       onPressed: () {},
//                       child: Text(
//                         'Chat\nngay',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.mainColor, // Màu nền
//                         foregroundColor: Colors.white, // Màu chữ
//                       ),
//                       onPressed: () {},
//                       child: Text(
//                         'Gọi điện',
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/room_detail_widget.dart';


class RoomDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/anh1.png',
      'assets/images/anh2.png',
      'assets/images/anh4.png',
    ];

    final List<List<String>> priceTable = [
      ['Điện', 'Nước', 'Xe', 'Quản lý'],
      ['3.800/kWh', '80.000/ng', '80.000/xe', '0/ph'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết phòng'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoomDetailWidget(
                productImages: images,
                roomName: 'Phòng thường - Lầu 2 - Máy lạnh',
                price: '4,000,000 VNĐ',
                address: '87/xx/xx Nguyễn Sỹ Sách, Phường 15, Quận Tân Bình, Thành phố Hồ Chí Minh',
                time: 'Tự do',
                priceTable: priceTable,
              ),
              SizedBox(height: 20),
              // Các nút
              Container(
                margin: EdgeInsets.only(top: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: Text(
                        '   Đặt lịch\nxem phòng',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Chat\nngay',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Gọi điện',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
