import 'package:timtro/Model/User.dart';

class Customer extends User {


  Customer({
    required String id,
    required String username,
    required String password,
    required String name,
    required String sdt,
    required String gmail,
    required String vaitro,
    required DateTime ngaytao,
    required String avturl
  }) : super(
    id: id,
    username: username,
    password: password,
    name: name,
    sdt: sdt,
    gmail: gmail,
    vaitro: "customer",
    ngaytao: ngaytao,
    avturl: avturl
  );

  // Phương thức fromJson cho Customer
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      sdt: json['sdt'] as String,
      gmail: json['gmail'] as String,
      vaitro: json['vaitro'] as String,
      ngaytao: DateTime.parse(json['ngaytao'] as String),
      avturl: json['avturl']
    );
  }

  // Phương thức toJson cho Customer
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson(); // Gọi phương thức toJson từ lớp cha

    return data;
  }
}
