import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/User.dart';
import 'package:timtro/utils/colors.dart';
import 'package:uuid/uuid.dart';

class CustomerInfoPage extends StatefulWidget {
  final Usercontroller usercontroller;

  CustomerInfoPage({required this.usercontroller});

  @override
  _CustomerInfoPageState createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  File? _avatarFile;
  User? user;
  String? urli;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isEditing = false; // Trạng thái chỉnh sửa

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
      // Thêm logic upload ảnh lên server tại đây nếu cần
    }
  }

  Future<void> _uploadImages() async {
    if (_avatarFile == null) return;

    try {
      final uuid = Uuid();
      final storageRef =
          FirebaseStorage.instance.ref().child("images/${uuid.v4()}");
      await storageRef.putFile(File(_avatarFile!.path));
      urli = await storageRef.getDownloadURL();
      print('Images uploaded successfully: $urli');
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    user = widget.usercontroller.user;

    // Gán giá trị ban đầu cho các bộ điều khiển
    if (user != null) {
      _nameController.text = user!.name;
      _phoneController.text = user!.sdt;
      _emailController.text = user!.gmail;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Thông tin cá nhân'),
          backgroundColor: AppColors.mainColor,
          actions: [
            TextButton(
              child: Text(isEditing ? "Save" : "Edit"),
              // icon: Icon(isEditing ? Icons.save : Icons.edit),
              onPressed: () async {
                if (isEditing) {
                  if (_nameController.text.isEmpty ||
                      _phoneController.text.isEmpty ||
                      _emailController.text.isEmpty) {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Vui lòng điền đầy đủ thông tin!")),
                      );
                    });
                    return;
                  }
                  await _uploadImages();
                  user!.name = _nameController.text;
                  user!.sdt = _phoneController.text;
                  user!.gmail = _emailController.text;
                  if (urli != null) user!.avturl = urli!;
                  int success = await widget.usercontroller.updateUser(user!);
                    if (success == 200 || success == 201) {
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Cập nhật thông tin thành công!")),
                        );
                      });

                    } else {
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Cập nhật thất bại!")),
                        );
                      });

                    }
                  widget.usercontroller.loadUI();
                }
                setState(() {
                  isEditing = !isEditing;
                });
                 // Chuyển đổi trạng thái chỉnh sửa
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _avatarFile != null
                          ? FileImage(_avatarFile!)
                          : (user?.avturl != null && user!.avturl.isNotEmpty)
                              ? NetworkImage(user!.avturl) as ImageProvider
                              : null,
                      child: (user?.avturl == null ||
                              user!.avturl.isEmpty) &&
                              _avatarFile == null
                          ? Icon(Icons.person, size: 70)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: isEditing ? _pickImage : null,
                        // Chỉ chọn ảnh khi đang chỉnh sửa
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt,
                              color: isEditing
                                  ? AppColors.mainColor
                                  : Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Thông tin cá nhân",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                ),
              ),
              SizedBox(height: 20),

              // Hiển thị thông tin các thuộc tính của User
              _buildInfoField(
                label: "Tên",
                controller: _nameController,
                isEnabled: isEditing,
              ),
              _buildInfoField(
                label: "Số điện thoại",
                controller: _phoneController,
                isEnabled: isEditing,
              ),
              _buildInfoField(
                label: "Email",
                controller: _emailController,
                isEnabled: isEditing,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm để tạo một trường thông tin có thể chỉnh sửa
  Widget _buildInfoField(
      {required String label,
      required TextEditingController controller,
      required bool isEnabled}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
