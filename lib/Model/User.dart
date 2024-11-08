import 'package:json_annotation/json_annotation.dart';


class User {
  String id;
  String username;
  String password;
  String name;
  String sdt;
  String gmail;
  String vaitro;
  DateTime ngaytao;
  String avturl;
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.sdt,
    required this.gmail,
    required this.vaitro,
    required this.ngaytao,
    required this.avturl
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      sdt: json['sdt'] as String,
      gmail: json['gmail'] as String,
      vaitro: json['vaitro'] as String,
      ngaytao: DateTime.parse(json['ngaytao'] as String),
      avturl: json ['avturl']==null ? "" : json ['avturl'] ,
    );
  }

  // Phương thức toJson để chuyển đối tượng User thành JSON
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
      'avturl': avturl
    };
  }

}
