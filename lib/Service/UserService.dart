import 'dart:convert';

import 'package:timtro/Model/Customer.dart';
import 'package:timtro/Model/User.dart';
import 'package:http/http.dart' as http;
import 'package:timtro/utils/dimensions.dart';
class Userservice{

  Future<User?> fetchUser(String userId) async {
    try {
      final response = await http.get(Uri.parse('${API.link}/$userId'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        // Xử lý lỗi khi không nhận được phản hồi hợp lệ
        print('Failed to load user: ${response.statusCode}');
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
}