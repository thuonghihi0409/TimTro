import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/User.dart';

import 'package:timtro/utils/colors.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usercontroler = context.watch<Usercontroller>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Form key để xác nhận form
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tìm Tro",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                // keyboardType: TextInputType.phone,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Vui lòng nhập username';
                //   } else if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
                //     return 'Số điện thoại không hợp lệ';
                //   }
                //   return null;
                // },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                      Icons.visibility_off), // Icon để ẩn hiện mật khẩu
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  User user = User(id: " ",
                      username: _usernameController.text,
                      password: _passwordController.text,
                      name: " ",
                      sdt: " ",
                      gmail: " ",
                      vaitro: " ",
                      ngaytao: DateTime.now());
                  usercontroler.login(user);
                  Navigator.pop(context);
                },
                child: Text('Đăng nhập'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor, // Màu nền của nút
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              // TextButton(
              //   onPressed: () {
              //     // Điều hướng đến trang đăng ký
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => RegisterPage(),
              //       ),
              //     );
              //   },
              //   child: Text('Bạn chưa có tài khoản? Đăng ký'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
