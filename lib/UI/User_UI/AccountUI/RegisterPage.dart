import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/Customer.dart';
import 'package:timtro/utils/colors.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Khóa để theo dõi trạng thái của form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final usercontroler = context.watch<Usercontroller>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Đăng ký'),
          backgroundColor: AppColors.mainColor,
        ),
        body: SingleChildScrollView(

          child: Padding(
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
                  SizedBox(height: 15),

                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Tên đăng nhập',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên đăng nhập';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Tên của bạn',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên của bạn';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
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
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Nhập email (nếu có)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      } else if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Xác nhận mật khẩu',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng xác nhận mật khẩu';
                      } else if (value != _passwordController.text) {
                        return 'Mật khẩu không khớp';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
          
                      //       if (_formKey.currentState!.validate())
                      if (true) {
                        // Lấy dữ liệu từ form và tạo đối tượng Customer
                        Customer newCustomer = Customer(
                          id: DateTime.now().toString(), // Hoặc cách lấy ID khác
                          username: _usernameController.text,
                          password: _passwordController.text,
                          name: _nameController.text,
                          sdt: _phoneController.text,
                          gmail: _emailController.text!= null ? _emailController.text :'',  // Bổ sung nếu có trường email
                          vaitro:"customer", // Giả định vai trò là "customer"
                          ngaytao: DateTime.now(),
                          avturl: " "
          
                        );
          
                        // Lưu Customer vào API (hàm này bạn sẽ phải tự xây dựng)

                        usercontroler.createCustomer(newCustomer);
                        usercontroler.setstate(1);
          
                        Navigator.pop(context);
          
                        // // Hiển thị SnackBar thông báo
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Đang xử lý đăng ký...')),
                        // );
                      }
                    },
                    child: Text('Đăng ký'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
          
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
