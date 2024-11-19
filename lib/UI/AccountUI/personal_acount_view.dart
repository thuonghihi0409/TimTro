// import 'package:flutter/material.dart';
//
// import 'package:timtro/utils/colors.dart';
//
//
//
// class PersonalAcountView extends StatelessWidget {
//   const PersonalAcountView({super.key});
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar( // Sử dụng AppBar
//           backgroundColor: AppColors.mainColor,
//           title: Row(
//             children: [
//               CircleAvatar(  // Thêm vòng tròn bao quanh icon
//                 radius: 18,  // Đặt bán kính của vòng tròn
//                 backgroundColor: Colors.white, // Màu nền của vòng tròn
//                 child: Icon(
//                   Icons.person,
//                   color: AppColors.mainColor, // Màu của icon bên trong
//                   size: 28,  // Kích thước icon
//                 ),
//               ),
//               const SizedBox(width: 10), // Khoảng cách giữa icon và text
//               const Text('Your name',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 17,        // Kích thước chữ
//                   // Đặt chữ in đậm
//                 ),
//               ), // Hiển thị tiêu đề
//             ],
//           ),
//         ),
//         body: Column(
//           children: [
//             SizedBox(
//               height: 300,
//               child: ListView(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.storefront, color: AppColors.mainColor),
//                     title: const Text('Đăng trọ'),
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => Post_Room_Page(),
//                       //   ),
//                       // );
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.logout, color: AppColors.mainColor),
//                     title: const Text('Đăng xuất'),
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => HomePage(),
//                       //   ),
//                       // );
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.info_rounded, color: AppColors.mainColor),
//                     title: const Text('Tin nhắn'),
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => (),
//                       //   ),
//                       // );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timtro/Model/User.dart';

class LandlordProfilePage extends StatelessWidget {
  final User landlord;

  const LandlordProfilePage({super.key, required this.landlord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang cá nhân chủ trọ'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar (Ảnh đại diện)
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(landlord.avturl),
              ),
            ),
            const SizedBox(height: 16),
            // Tên chủ trọ
            Center(
              child: Text(
                landlord.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            // Số điện thoại
            Text('Số điện thoại: ${landlord.sdt}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            // Email
            Text('Email: ${landlord.gmail}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            // Thêm các nút chức năng
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút nhắn tin
                ElevatedButton.icon(
                  onPressed: () {
                    // Mở giao diện nhắn tin hoặc tạo cuộc trò chuyện
                    // Ví dụ: Navigator.push(...)
                    // Bạn có thể tích hợp với chức năng chat đã có trong ứng dụng của mình
                    print('Nhắn tin cho chủ trọ');
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Nhắn tin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20),
                // Nút gọi điện
                ElevatedButton.icon(
                  onPressed: () async {
                    final Uri phoneUri = Uri(
                      scheme: 'tel',
                      path: landlord.sdt,
                    );

                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    } else {
                      print('Không thể gọi đến ${landlord.sdt}');
                    }
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Gọi điện'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Các thông tin khác (nếu có)
            // Ví dụ: Mô tả về chủ trọ, địa chỉ...
          ],
        ),
      ),
    );
  }
}
