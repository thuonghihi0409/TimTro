import 'dart:io';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/RentelProperty.dart';
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
  String url = "";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _electricityWaterPriceController =
      TextEditingController();

  bool wifiAvailable = false;
  bool parkingAvailable = false;
  bool airConditioningAvailable = false;

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  LatLng _selectedLocation =
      LatLng(10.8231, 106.6297); // Vị trí mặc định ban đầu

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      final uuid = Uuid();
      final storageRef =
          FirebaseStorage.instance.ref().child("images/${uuid.v4()}");
      await storageRef.putFile(File(_imageFile!.path));
      url = await storageRef.getDownloadURL();
      print('Image uploaded successfully: $url');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final usercontroller = context.watch<Usercontroller>();
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
                    decoration:
                        InputDecoration(labelText: 'Giá điện nước (VNĐ)'),
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
                        final rentalcontroller =
                            context.read<Rentalpropertycontroller>();
                        await _uploadImage();
                        RentalProperty rentalproperty = RentalProperty(
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
                          landlord: usercontroller.user!,
                          // latitude: _selectedLocation.latitude, // Tọa độ đã chọn
                          // longitude: _selectedLocation.longitude,
                        );
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