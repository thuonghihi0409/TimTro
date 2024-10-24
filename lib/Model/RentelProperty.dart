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
  String image;
  DateTime postDate;
  DateTime updateDate;
  String landlordId;

  RentalProperty({
    required this.propertyId,
    required this.propertyName,
    required this.address,
    required this.rentPrice,
    required this.description,
    required this.area,
    required this.availableRooms,
    required this.image,
    required this.postDate,
    required this.updateDate,
    required this.landlordId,
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
    User user = User.fromJson(json ["landlord"]);
    return RentalProperty(
      propertyId: json['propertyId'] as String,
      propertyName: json['propertyName'] as String,
      address: json['address'] as String,
      rentPrice: json['rentPrice'] as String,
      description: json['description'] as String,
      area: (json['area'] as num).toDouble(), // Chuyển đổi số thành double
      availableRooms: json['availableRooms'] as int,
      image: json['image'] as String,
      postDate: DateTime.parse(json['postDate'] as String),
      updateDate: DateTime.parse(json['updateDate'] as String),
      landlordId: user.id as String,  // Chuyển đổi đối tượng Landlord
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
      'image': image,
      'postDate': postDate.toIso8601String(),
      'updateDate': updateDate.toIso8601String(),
      'landlordId': landlordId,
    };
  }
}