import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/UI/AccountUI/LoginPage.dart';
import 'package:timtro/UI/AccountUI/ManagemnetRental.dart';
import 'package:timtro/UI/RentalpropertyUI/UploadImage.dart';
import 'package:timtro/UI/RentalpropertyUI/find_tab.dart';
import 'package:timtro/UI/AccountUI/info_customer.dart';
import 'package:timtro/UI/RentalpropertyUI/room_detail_page.dart';
import 'package:timtro/UI/RentalpropertyUI/upRentalpropertyscreen.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/big_text.dart';
import 'package:timtro/widgets/icon_and_text_widget.dart';
import 'package:timtro/widgets/small_text.dart';
import '../../Model/RentelProperty.dart';
import 'RegisterPage.dart';

class AccountTab1 extends StatelessWidget {
  const AccountTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final usercontroller = context.watch<Usercontroller>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.mainColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Tài khoản khách',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView(
            children: [
              _buildListTile(
                context,
                icon: Icons.person_add,
                title: 'Đăng ký',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildListTile(
                context,
                icon: Icons.login,
                title: 'Đăng nhập',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildListTile(
                context,
                icon: Icons.info_rounded,
                title: 'Về chúng tôi',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      Color iconColor = AppColors.mainColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[300]);
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

//=============================================================

class AccountTab2 extends StatefulWidget {
  const AccountTab2({super.key});

  @override
  State<AccountTab2> createState() => _AccountTab2State();
}

class _AccountTab2State extends State<AccountTab2> {


  @override
  Widget build(BuildContext context) {
    final usercontroller = context.watch<Usercontroller>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.mainColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${usercontroller.user?.name}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Cài đặt tài khoản',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildListTile(
                    context,
                    icon: Icons.person_add,
                    title: 'Thông tin cá nhân',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerInfoPage(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon: Icons.login,
                    title: 'Đăng trọ',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadRentalPropertyScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon: Icons.info,
                    title: 'Về chúng tôi',
                    onTap: () => _showAboutDialog(context),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    onTap: () =>
                        _showLogoutConfirmation(context, usercontroller),
                    iconColor: Colors.red,
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon: Icons.manage_accounts_outlined,
                    title: 'Quan ly bai dang',
                    onTap: () =>{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MyRental()))
                    },
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // if (listRental.isNotEmpty)
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: listRental.length,
            //       itemBuilder: (context, index) {
            //         return Item(
            //           listRental: listRental,
            //           index: index,
            //         );
            //       },
            //     ),
            //   )
            // else
            //   Padding(
            //     padding: const EdgeInsets.only(top: 20),
            //     child: Text(
            //       'Chưa có bất động sản nào.',
            //       style: TextStyle(
            //         fontSize: 16,
            //         color: Colors.grey,
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap,
      Color iconColor = AppColors.mainColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[300]);
  }
}



//=============================================================

void _showLogoutConfirmation(
    BuildContext context, Usercontroller usercontroller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            onPressed: () {
              usercontroller.logout();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

