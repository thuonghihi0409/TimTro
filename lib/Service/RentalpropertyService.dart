import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/utils/dimensions.dart';

class Rentalpropertyservice {

  Future<List<RentalProperty>> fetchRentalProperties() async {
    try {
      final response = await http.get(Uri.parse("${API.link}/rentalproperty"));
      if (response.statusCode == 200) {
        print("hihi");
        // If the server returns a 200 OK response, parse the JSON
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((property) => RentalProperty.fromJson(property))
            .toList();
      } else {
        throw Exception('Failed to load rental properties');
      }
    } catch (e) {
      print('Error fetching rental properties: $e');
      return [];
    }
  }

  Future<bool> postRentalProperty(RentalProperty property) async {
    try {
      final url = Uri.parse("${API.link}/rentalproperty");  // Đường dẫn API
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(property.toJson()),  // Chuyển dữ liệu tài sản thành JSON
      );

      if (response.statusCode == 201) {
        print('Property posted successfully');
        return true; // Trả về true nếu đăng tin thành công
      } else {
        print('Failed to post property: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error posting property: $e');
      return false;
    }
  }

}