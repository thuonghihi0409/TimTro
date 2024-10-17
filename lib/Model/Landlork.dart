import 'package:json_annotation/json_annotation.dart';
import 'User.dart'; // Đảm bảo bạn đã tạo lớp User trước




class Landlord extends User {
  Landlord({
    required String id,
    required String username,
    required String password,
    required String name,
    required String sdt,
    required String gmail,
    required String vaitro,
    required DateTime ngaytao,
  }) : super(
          id: id,
          username: username,
          password: password,
          name: name,
          sdt: sdt,
          gmail: gmail,
          vaitro: "landlork",
          ngaytao: ngaytao,
        );

  factory Landlord.fromJson(Map<String, dynamic> json) {
    return Landlord(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      sdt: json['sdt'] as String,
      gmail: json['gmail'] as String,
      vaitro: json['vaitro'] as String,
      ngaytao: DateTime.parse(json['ngaytao'] as String),
    );
  }

  // Phương thức toJson cho Landlord
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'sdt': sdt,
      'gmail': gmail,
      'vaitro': vaitro,
      'ngaytao': ngaytao.toIso8601String(),
    };
  }

  // Method to create a new landlord
  void createLandlord() {
    // Logic for creating a landlord
    print('Landlord created: $name');
  }

  // Method to post a property
  void postProperty() {
    // Logic for posting a property
    print('Property posted by: $name');
  }


}
