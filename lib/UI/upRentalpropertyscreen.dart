import 'dart:io';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadRentalPropertyScreen extends StatefulWidget {
  @override
  _UploadRentalPropertyScreenState createState() =>
      _UploadRentalPropertyScreenState();
}

class _UploadRentalPropertyScreenState
    extends State<UploadRentalPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  String url = "";

  // Các controller để lưu dữ liệu từ người dùng
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _electricityWaterPriceController =
      TextEditingController();

  // Biến lưu trữ tiện ích
  bool wifiAvailable = false;
  bool parkingAvailable = false;
  bool airConditioningAvailable = false;

  // Biến lưu ảnh đã chọn
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Hàm chọn ảnh
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      // Lấy đường dẫn tham chiếu đến Firebase Storage
      final uuid = Uuid();
      final storageRef =
          FirebaseStorage.instance.ref().child("images/${uuid.v4()}");
      // Tải lên tệp
      await storageRef.putFile(File(_imageFile!.path));

      // Lấy URL của tệp đã tải lên
      url = await storageRef.getDownloadURL();

      print('Image uploaded successfully: $url');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final usercontroler = context.watch<Usercontroller>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đăng tin cho thuê trọ'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Tên trọ'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên trọ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Địa chỉ'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập địa chỉ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Giá trọ (VNĐ)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập giá trọ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _electricityWaterPriceController,
                    decoration: InputDecoration(labelText: 'Giá điện nước (VNĐ)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập giá điện nước';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Tiện ích:'),
                  CheckboxListTile(
                    title: Text('Wi-Fi miễn phí'),
                    value: wifiAvailable,
                    onChanged: (bool? value) {
                      setState(() {
                        wifiAvailable = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Chỗ đậu xe'),
                    value: parkingAvailable,
                    onChanged: (bool? value) {
                      setState(() {
                        parkingAvailable = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Máy lạnh'),
                    value: airConditioningAvailable,
                    onChanged: (bool? value) {
                      setState(() {
                        airConditioningAvailable = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _imageFile == null
                      ? Text('Chưa chọn hình ảnh')
                      : Image.file(File(_imageFile!.path)),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Chọn hình ảnh'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final rentalcontroller = context.read<Rentalpropertycontroller>();
                         await _uploadImage();
                        RentalProperty rentalproperty = new RentalProperty(
                            propertyId: "hihi",
                            propertyName: _nameController.text,
                            address: _addressController.text,
                            rentPrice: _priceController.text,
                            description: "mo ta ",
                            area: 50,
                            availableRooms: 1,
                            image: url,
                            postDate: DateTime.now(),
                            updateDate: DateTime.now(),
                            landlord: usercontroler.user!);
                        print("00000000000000000000000");
                        rentalcontroller.postRental(rentalproperty);
                        Navigator.pop(context);
                      }
      
                    },
                    child: Text('Đăng tin'),
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
