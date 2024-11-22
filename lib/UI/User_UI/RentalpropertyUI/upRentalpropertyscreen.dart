import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/Model/Utility.dart';
import 'package:timtro/Service/Mapservice.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UploadRentalPropertyScreen extends StatefulWidget {
  @override
  _UploadRentalPropertyScreenState createState() =>
      _UploadRentalPropertyScreenState();
}

class _UploadRentalPropertyScreenState
    extends State<UploadRentalPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isUploading = false; // Cờ để hiển thị loading khi đang đăng
  List<String> url = [];
  List<Utility> listUtilities = [];
  List<bool> isChecked = [];
  List<Utility> listUtilitiesOfRental = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _electricityPriceController = TextEditingController();
  TextEditingController _waterPriceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _availableRoomsController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  List<XFile> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  LatLng _selectedLocation = LatLng(10.8231, 106.6297);
  String _locationMessage="";
  String? urlmap;
  @override
  void initState() {
    super.initState();
    _fetchUtilities();
    isChecked = List<bool>.filled(listUtilities.length, false);
    _addressController.text=_locationMessage;
  }



  Future<void> _pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles.addAll(pickedFiles);
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_imageFiles.isEmpty) return;

    try {
      final uuid = Uuid();
      for (var imageFile in _imageFiles) {
        final storageRef =
            FirebaseStorage.instance.ref().child("images/${uuid.v4()}");
        await storageRef.putFile(File(imageFile.path));
        String urli = await storageRef.getDownloadURL();
        url.add(urli);
      }
      print('Images uploaded successfully: $url');
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  void _fetchUtilities() async {
    listUtilities =
        await context.read<Rentalpropertycontroller>().getUtilities();
    setState(() {
      isChecked = List<bool>.filled(listUtilities.length, false);
      isLoading = false;
    });
  }

  Future<void> _handlePostRental() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isUploading = true;
        // Hiển thị loading khi bắt đầu đăng
      });

      await _uploadImages();

      double area = double.tryParse(_areaController.text) ?? 0.0;
      int availableRooms = int.tryParse(_availableRoomsController.text) ?? 0;

      RentalProperty rentalProperty = RentalProperty(
        propertyId: "hihi",
        propertyName: _nameController.text,
        address: _addressController.text,
        rentPrice: _priceController.text,
        description: _descriptionController.text,
        area: area,
        availableRooms: availableRooms,
        images: url,
        waterPrice: _waterPriceController.text,
        electricPrice: _electricityPriceController.text,
        postDate: DateTime.now(),
        updateDate: DateTime.now(),
        urlmap: urlmap ?? "",
        numberViewer: 0,
        landlord: context.read<Usercontroller>().user!,
        status: 1,
      );
      print("so tien ich ==============  ${listUtilitiesOfRental.length}");
      await context
          .read<Rentalpropertycontroller>()
          .postRental(rentalProperty, listUtilitiesOfRental);
      setState(() {
        isUploading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã đăng trọ thành công")));
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Đăng tin cho thuê trọ')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                      _nameController, 'Tên trọ', 'Vui lòng nhập tên trọ',
                      icon: Icons.home),
                  _buildTextField(_priceController, 'Giá trọ (VNĐ)',
                      'Vui lòng nhập giá trọ',
                      isNumber: true, icon: Icons.money),
                  _buildTextField(_electricityPriceController, 'Giá điện (VNĐ)',
                      'Vui lòng nhập giá điện',
                      isNumber: true, icon: Icons.flash_on),
                  _buildTextField(_waterPriceController, 'Giá nước (VNĐ)',
                      'Vui lòng nhập giá nước',
                      isNumber: true, icon: Icons.water),
                  _buildTextField(_availableRoomsController, 'Số phòng trống',
                      'Vui lòng nhập số phòng trống',
                      isNumber: true, icon: Icons.meeting_room),
                  _buildTextField(_areaController, 'Diện tích (m²)',
                      'Vui lòng nhập diện tích',
                      isNumber: true, icon: Icons.square_foot),
                  _buildTextField(_descriptionController, 'Mô tả', '',
                      icon: Icons.description),
                  const SizedBox(height: 16),
                  _buildTextField(
                      _addressController, 'Địa chỉ', 'Vui lòng nhập địa chỉ',
                      icon: Icons.location_on),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        Mapservice mapservice = Mapservice();
                        String tepm= await mapservice.getCurrentLocation();
                        urlmap=  await mapservice.getGoogleMapsLink();
                       setState(() {
                         _locationMessage= tepm;
                         _addressController.text=_locationMessage;

                       });
                      },
                      child: Center(child: Text("Lấy vị trí hiện tại"))),
                  Text('Tiện ích:'),
                  ...listUtilities.asMap().entries.map((entry) {
                    return CheckboxListTile(
                      title: Text(entry.value.utilityName),
                      value: isChecked[entry.key],
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked[entry.key] = value ?? false;
                          if (value == true) {
                            listUtilitiesOfRental.add(entry.value);
                          } else {
                            listUtilitiesOfRental.remove(entry.value);
                          }
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  _buildSelectedImages(),
                  ElevatedButton(
                    onPressed: _pickMultipleImages,
                    child: Center(child: Text('Chọn hình ảnh')),
                  ),
                  const SizedBox(height: 16),
                  isUploading
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                          child: ElevatedButton(
                            onPressed: _handlePostRental,
                            child: Text('Đăng tin'),
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

  Widget _buildTextField(
      TextEditingController controller, String label, String errorMsg,
      {bool isNumber = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Nhập $label',
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return errorMsg;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSelectedImages() {
    return _imageFiles.isEmpty
        ? Center(child: Text('Chưa chọn hình ảnh'))
        : SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageFiles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    File(_imageFiles[index].path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          );
  }
}
