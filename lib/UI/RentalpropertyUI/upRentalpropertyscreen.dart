import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/Model/Utility.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'MapScreen.dart';

class UploadRentalPropertyScreen extends StatefulWidget {
  @override
  _UploadRentalPropertyScreenState createState() =>
      _UploadRentalPropertyScreenState();
}

class _UploadRentalPropertyScreenState
    extends State<UploadRentalPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  List<String> url = [];
  List<Utility> listUtilities = [];
  List<bool> isChecked =[];
  List<Utility> listUtilitiesOfRental=[];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _electricityPriceController = TextEditingController();
  TextEditingController _waterPriceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _availableRoomsController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  bool wifiAvailable = false;
  bool parkingAvailable = false;
  bool airConditioningAvailable = false;

  List<XFile> _imageFiles = [];

  final ImagePicker _picker = ImagePicker();

  LatLng _selectedLocation =
      LatLng(10.8231, 106.6297); // Vị trí mặc định ban đầu

  @override
  void initState() {
    super.initState();

    _fetchUtilies();
    isChecked = List<bool>.filled(listUtilities.length, false);

  }

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        for (var pickedFile in pickedFiles) {
          // Lưu các tệp ảnh đã chọn
          _imageFiles.add(pickedFile);
        }
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

  void _fetchUtilies() async {
     listUtilities = await context.read<Rentalpropertycontroller>().getUtilities() ; // Đợi hàm lấy dữ liệu hoàn tất
    setState(() {
      isChecked = List<bool>.filled(listUtilities.length, false);
      isLoading = false; // Đặt cờ thành false sau khi dữ liệu đã được tải
    });
  }
  @override
  Widget build(BuildContext context) {
    final usercontroller = context.watch<Usercontroller>();
    final rentalcontroller = context.read<Rentalpropertycontroller>();
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
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
                    controller: _electricityPriceController,
                    decoration: InputDecoration(labelText: 'Giá điện (VNĐ)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập giá điện';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _waterPriceController,
                    decoration: InputDecoration(labelText: 'Giá nước (VNĐ)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập giá nước';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _availableRoomsController,
                    decoration: InputDecoration(labelText: 'Số phòng trống'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng số phong trống';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: _areaController,
                    decoration: InputDecoration(labelText: 'Diện tích'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng diện tích';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'mô tả'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),

                  Text('Tiện ích:'),
                  if (listUtilities.isNotEmpty)
                    ...listUtilities
                        .asMap()
                        .entries
                        .map((entry) => CheckboxListTile(
                      title: Text(entry.value.utilityName),
                      value: isChecked[entry.key] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked[entry.key] = value ?? false;
                          //isChecked[entry.key]= !isChecked[entry.key];
                          if (value == true) {
                            listUtilitiesOfRental.add(entry.value);
                          } else {
                            listUtilitiesOfRental.remove(entry.value);
                          }
                        });
                      },
                    ))
                        .toList(),

                  SizedBox(height: 16),
                  _buildSelectedImages(),
                  ElevatedButton(
                    onPressed: _pickMultipleImages,
                    child: Text('Chọn hình ảnh'),
                  ),
                  SizedBox(height: 16),
                  // Bản đồ chọn vị trí
                  Text('Chọn vị trí trên bản đồ:'),
                  SizedBox(
                    height: 300,
                    child: FlutterMap(
                      options: MapOptions(
                        center: _selectedLocation,
                        zoom: 13.0,
                        onTap: (tapPosition, point) {
                          setState(() {
                            _selectedLocation = point;
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _selectedLocation,
                              builder: (ctx) => Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {

                      if (_formKey.currentState!.validate()) {
                        await _uploadImages();
                        double area =
                            double.tryParse(_areaController.text) ?? 0.0;
                        int number = int.tryParse(_areaController.text) ?? 0;
                        RentalProperty rentalproperty = RentalProperty(
                          propertyId: "hihi",
                          propertyName: _nameController.text,
                          address: _addressController.text,
                          rentPrice: _priceController.text,
                          description: _descriptionController.text ?? " ",
                          area: area,
                          availableRooms: number,
                          images: url?? [],
                          waterPrice: _waterPriceController.text.toString(),
                          electricPrice:
                              _electricityPriceController.text.toString(),
                          postDate: DateTime.now(),
                          updateDate: DateTime.now(),
                          landlord: usercontroller.user!,
                          status: 0,
                          // latitude: _selectedLocation.latitude, // Tọa độ đã chọn
                          // longitude: _selectedLocation.longitude,
                        );

                        await rentalcontroller.postRental(rentalproperty, listUtilitiesOfRental);
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

  Widget _buildSelectedImages() {
    return _imageFiles.isEmpty
        ? Text('Chưa chọn hình ảnh')
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

// class UploadRentalPropertyScreen extends StatefulWidget {
//   @override
//   _UploadRentalPropertyScreenState createState() =>
//       _UploadRentalPropertyScreenState();
// }
//
// class _UploadRentalPropertyScreenState extends State<UploadRentalPropertyScreen> {
//   String _selectedAddress = "Chưa chọn địa chỉ";
//   TextEditingController _addressController = TextEditingController();
//
//   void _openMapScreen() async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MapScreen(
//           onLocationSelected: (address) {
//             setState(() {
//               _selectedAddress = address;
//               _addressController.text = address;
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Đăng tin cho thuê trọ'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _addressController,
//               decoration: InputDecoration(labelText: 'Địa chỉ'),
//               readOnly: true,
//             ),
//             IconButton(
//               icon: Icon(Icons.map),
//               onPressed: _openMapScreen,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
