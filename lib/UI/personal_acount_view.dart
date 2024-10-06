import 'package:flutter/material.dart';

import 'package:timtro/utils/colors.dart';



class PersonalAcountView extends StatelessWidget {
  const PersonalAcountView({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Sử dụng AppBar
        backgroundColor: AppColors.mainColor,
        title: Row(
          children: [
            CircleAvatar(  // Thêm vòng tròn bao quanh icon
              radius: 18,  // Đặt bán kính của vòng tròn
              backgroundColor: Colors.white, // Màu nền của vòng tròn
              child: Icon(
                Icons.person,
                color: AppColors.mainColor, // Màu của icon bên trong
                size: 28,  // Kích thước icon
              ),
            ),
            const SizedBox(width: 10), // Khoảng cách giữa icon và text
            const Text('Your name',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,        // Kích thước chữ
                // Đặt chữ in đậm
              ),
            ), // Hiển thị tiêu đề
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.storefront, color: AppColors.mainColor),
                  title: const Text('Đăng trọ'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Post_Room_Page(),
                    //   ),
                    // );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: AppColors.mainColor),
                  title: const Text('Đăng xuất'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => HomePage(),
                    //   ),
                    // );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_rounded, color: AppColors.mainColor),
                  title: const Text('Tin nhắn'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => (),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


