import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/UI/LoginPage.dart';
import 'package:timtro/UI/UploadImage.dart';
import 'package:timtro/UI/info_customer.dart';
import 'package:timtro/UI/upRentalpropertyscreen.dart';
import 'package:timtro/utils/colors.dart';
import 'RegisterPage.dart';

class AccountTab1 extends StatelessWidget {
  const AccountTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final usercontroler = context.watch<Usercontroller>();
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
            const Text('Tài khoản khách',
              style: TextStyle(
                color: Colors.black, // Đổi màu chữ thành màu trắng
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
                  leading: Icon(Icons.person_add, color: AppColors.mainColor),
                  title: const Text('Đăng ký'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.login, color: AppColors.mainColor),
                  title: const Text('Đăng nhập'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_rounded, color: AppColors.mainColor),
                  title: const Text('Về chúng tôi'),
                  onTap: () {
                    _showAboutDialog(context);
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

class AccountTab2 extends StatelessWidget {
  const AccountTab2 ({super.key});

  @override
  Widget build(BuildContext context) {
    final usercontroler = context.watch<Usercontroller>();
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
            Text('${usercontroler.user?.name}',
              style: TextStyle(
                color: Colors.black, // Đổi màu chữ thành màu trắng
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
                  leading: Icon(Icons.person_add, color: AppColors.mainColor),
                  title: const Text('Thông tin cá nhân'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerInfoPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.login, color: AppColors.mainColor),
                  title: const Text('Đăng trọ'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadRentalPropertyScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_rounded, color: AppColors.mainColor),
                  title: const Text('Về chúng tôi'),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_rounded, color: AppColors.mainColor),
                  title: const Text('Đăng xuất'),
                  onTap: () {
                    usercontroler.logout();
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

void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Về chúng tôi'),
        content: const Text('Nội dung về chúng tôi...'),
        actions: [
          TextButton(
            child: const Text('Đóng'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
