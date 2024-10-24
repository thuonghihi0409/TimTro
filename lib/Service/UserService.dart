import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timtro/Model/Customer.dart';
import 'package:timtro/Model/User.dart';
import 'package:http/http.dart' as http;
import 'package:timtro/utils/dimensions.dart';
class Userservice{

  Future<User?> fetchUser(String username) async {
    try {
      final response = await http.get(Uri.parse('${API.link}/users/username=$username'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
       // print("${jsonResponse}");
        User user= User.fromJson(jsonResponse);
       // print("${user.username}");
        return User.fromJson(jsonResponse);
      } else {
        // Xử lý lỗi khi không nhận được phản hồi hợp lệ
        print('Failed to load user: $username ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Xử lý lỗi khi có ngoại lệ
      print('Error occurred: $e');
      return null;
    }
  }

  Future<int> saveCustomerToAPI(Customer customer) async {
    // Gọi API để lưu dữ liệu
    final response = await http.post(
      Uri.parse('${API.link}/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(customer.toJson()),
    );
    return response.statusCode;
  }

  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }
  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
  Future<void> removeUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
  }
}