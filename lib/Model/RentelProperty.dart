import 'package:timtro/Model/Landlork.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:timtro/Model/User.dart';

class RentalProperty {
  final Reference storageRef = FirebaseStorage.instance.ref().child("images");
  String propertyId;
  String propertyName;
  String address;
  String rentPrice;
  String description;
  double area;
  int availableRooms;
  List<String> images;
  String waterPrice;
  String electricPrice;
  DateTime postDate;
  DateTime updateDate;
  String urlmap;
  User landlord;
  int status;
  int numberViewer;
  RentalProperty({
    required this.propertyId,
    required this.propertyName,
    required this.address,
    required this.rentPrice,
    required this.description,
    required this.area,
    required this.availableRooms,
    required this.images,
    required this.waterPrice,
    required this.electricPrice,
    required this.postDate,
    required this.updateDate,
    required this.urlmap,
    required this.landlord,
    required this.status,
    required this.numberViewer,
  });

  // Getters and setters are handled naturally in Dart by accessing the fields directly.

  // Method to edit property info, returns a list of changes
  List<String> editPropertyInfo() {
    // Add logic for editing property info
    List<String> changes = [];
    changes.add('Property info edited');
    return changes;
  }

  // Method to delete a property
  void deleteProperty() {
    // Add logic for deleting the property
    print('Property deleted: $propertyId');
  }

  factory RentalProperty.fromJson(Map<String, dynamic> json) {
    return RentalProperty(
      propertyId: json['propertyId'] as String,
      propertyName: json['propertyName'] as String,
      address: json['address'] as String,
      rentPrice: json['rentPrice'] as String,
      description: json['description'] as String,
      area: (json['area'] as num).toDouble(), // Chuyển đổi số thành double
      availableRooms: json['availableRooms'] as int,
      images: List<String>.from(json['images'] ?? []),
      waterPrice: json['waterPrice'] ?? "0" as String ,
      electricPrice: json['electricPrice'] ?? "0" as String ,
      postDate: DateTime.parse(json['postDate'] as String),
      updateDate: DateTime.parse(json['updateDate'] as String),
      urlmap: json["urlmap"] ?? "" as String,
      landlord: User.fromJson(json ["landlord"]),
      status: json["status"] ?? 0 as int,
      numberViewer: json["numberViewer"] ?? 0 as int,// Chuyển đổi đối tượng Landlord
    );
  }

  // Phương thức toJson cho RentalProperty
  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'propertyName': propertyName,
      'address': address,
      'rentPrice': rentPrice,
      'description': description,
      'area': area,
      'availableRooms': availableRooms,
      'images': images,
      'waterPrice': waterPrice,
      'electricPrice': electricPrice,
      'postDate': postDate.toIso8601String(),
      'updateDate': updateDate.toIso8601String(),
      'landlordId': landlord.id,
      "status": status,
      "urlmap":urlmap,
      "numberViewer": numberViewer,
    };
  }
  double getNumericRentPrice() {
    //print("Rent Price: $rentPrice"); // Kiểm tra giá trị rentPrice
    String priceStr = rentPrice.replaceAll(RegExp(r'[^\d]'), ''); // Loại bỏ ký tự không phải số
    // print("Cleaned Rent Price: $priceStr"); // Kiểm tra giá trị sau khi đã loại bỏ ký tự không phải số
    return double.tryParse(priceStr) ?? 0.0;
  }
}