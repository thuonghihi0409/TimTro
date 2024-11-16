import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/utils/colors.dart';

class CustomerInfoPage extends StatefulWidget {
  @override
  _CustomerInfoPageState createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _membershipLevelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usercontroler = context.watch<Usercontroller>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thông tin cá nhân'),
          backgroundColor: AppColors.mainColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                "Thông tin cá nhân",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
              SizedBox(height: 20),

              // Tên của khách hàng
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '${usercontroler.user?.name}',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Chỉ để hiển thị, không chỉnh sửa
              ),
              SizedBox(height: 10),

              // Số điện thoại của khách hàng
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: '${usercontroler.user?.sdt}',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Chỉ để hiển thị
              ),
              SizedBox(height: 10),

              // Email của khách hàng
              TextFormField(
                controller: _gmailController,
                decoration: InputDecoration(
                  labelText: '${usercontroler.user?.gmail}',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Chỉ để hiển thị
              ),
              SizedBox(height: 10),

              // Cấp độ thành viên
              TextFormField(
                controller: _membershipLevelController,
                decoration: InputDecoration(
                  labelText: 'Cấp độ thành viên',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Chỉ để hiển thị
              ),
              SizedBox(height: 20),

              // Nút để chỉnh sửa thông tin cá nhân
              ElevatedButton(
                onPressed: () {
                  // Thêm chức năng chỉnh sửa thông tin tại đây
                },
                child: Text('Chỉnh sửa thông tin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
