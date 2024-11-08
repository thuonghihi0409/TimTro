import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/utils/dimensions.dart';

class Rentalpropertyservice {

  Future<List<RentalProperty>> fetchRentalProperties() async {
    try {
      final response = await http.get(
        Uri.parse("${API.link}/rentalproperty"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print("hihi ${json.decode(utf8.decode(response.bodyBytes))}");
        final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
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


  Future <List <RentalProperty>> getRentalByLandLord(String id) async {
    try {
      final response = await http.get(
        Uri.parse("${API.link}/rentalproperty/landlord=${id}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print("hihi ${json.decode(utf8.decode(response.bodyBytes))}");
        final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
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
      final url = Uri.parse("${API.link}/rentalproperty");
      print("${property.toJson()}");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // Đảm bảo thêm charset
        },
        body: jsonEncode(property.toJson()),
      );

      if (response.statusCode == 201) {
        print('Property posted successfully');
        return true;
      } else if (response.statusCode == 400) {
        print('Bad Request: ${response.body}');
      } else if (response.statusCode == 401) {
        print('Unauthorized: Please check your credentials');
      } else if (response.statusCode == 500) {
        print('Server Error: Please try again later');
      } else {
        print('Failed to post property: ${response.statusCode}, ${response.body}');
      }
      return false;
    } catch (e) {
      print('Error posting property: $e');
      return false;
    }
  }

}