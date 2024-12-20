import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timtro/Model/Customer.dart';
import 'package:timtro/Model/User.dart';
import 'package:http/http.dart' as http;
import 'package:timtro/utils/dimensions.dart';
class Userservice{

  Future<User?> fetchUser(String username) async {
    try {
      final response = await http.get(Uri.parse('${API.link}/users/username=$username'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
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
    //print("${customer.toJson()}");
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

  Future<int> updateUserToAPI(User user) async {
    //print("${customer.toJson()}");
    // Gọi API để lưu dữ liệu
    final response = await http.put(
      Uri.parse('${API.link}/users/userid=${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
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

  Future<User?> login(User user) async {
    try {
      //print("${user!.toJson()}");
      final response = await http.post(
        Uri.parse('${API.link}/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // print("${jsonResponse}");
        User user= User.fromJson(jsonResponse);
        // print("${user.username}");
        return User.fromJson(jsonResponse);
      } else {
        // Xử lý lỗi khi không nhận được phản hồi hợp lệ
        print('Failed to load user:  ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Xử lý lỗi khi có ngoại lệ
      print('Error occurred: $e');
      return null;
    }
  }

  Future<List<User>> fetchAllUsers() async {

    final response = await http.get(
      Uri.parse('${API.link}/users'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      // Decode và log response body
      final String responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(responseBody);
      List<User> users = data.map((userJson) => User.fromJson(userJson)).toList();
      users = users.where((user) => user.vaitro.toLowerCase() != "admin").toList();
      return users;
    } else {
      throw Exception("Failed to load users. Status code: ${response.statusCode}");
    }

  }


  Future<bool> deleteUser(String userId) async {

    final response = await http.delete(Uri.parse("${API.link}/users/userid=$userId"));

    if (response.statusCode == 200) {
      return true; // Xóa thành công
    } else {

      return false; // Xóa thất bại
    }
  }
}