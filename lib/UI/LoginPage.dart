import 'package:flutter/material.dart';

import 'package:timtro/utils/colors.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  } else if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off), // Icon để ẩn hiện mật khẩu
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
                  if (_formKey.currentState!.validate()) {
                    // Kiểm tra dữ liệu hợp lệ và xử lý đăng nhập ở đây
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đang xử lý đăng nhập...')),
                    );
                  }
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
