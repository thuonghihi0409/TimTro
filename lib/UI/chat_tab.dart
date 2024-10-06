// import 'package:flutter/material.dart';
//
// class ChatTab extends StatelessWidget {
//   const ChatTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text("Chat tab"),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:timtro/utils/colors.dart';

class ChatTab extends StatefulWidget {
  @override
  _ChatTab createState() => _ChatTab();
}

class _ChatTab extends State<ChatTab> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  String? _name;
  String? _phoneNumber;
  bool _isStudent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin của bạn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText:
                'Tên của bạn'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên của bạn';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Radio(
                    value: 'Nam',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as String;
                      });
                    },
                    activeColor: AppColors.mainColor,
                  ),
                  Text('Nam'),
                  Radio(
                    value: 'Nữ',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as String;
                      });
                    },
                    activeColor: AppColors.mainColor
                  ),
                  Text('Nữ'),
                  Radio(
                    value: 'Khác',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as String;
                      });
                    },
                    activeColor: AppColors.mainColor
                  ),
                  Text('Khác'),
                ],
              ),
              SwitchListTile(
                title: Text('Bạn là sinh viên'),
                value: _isStudent,
                onChanged: (value) {
                  setState(() {
                    _isStudent = value;
                  });

                },
                activeTrackColor: AppColors.mainColor,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainColor, // Màu nền
                  foregroundColor: Colors.white, // Màu chữ
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Xử lý khi người dùng nhấn nút "Vào chat ngay"
                    // Ví dụ: gửi dữ liệu lên server
                    print('Tên: $_name');
                    print('Số điện thoại: $_phoneNumber');
                    print('Giới tính: $_gender');
                    print('Sinh viên: $_isStudent');
                  }

                },
                child: Text('Vào chat ngay',
                              style: TextStyle(
                                color: Colors.black
                              ),
                            ),
              ),
            ],

          ),
        ),
      ),

    );
  }
}