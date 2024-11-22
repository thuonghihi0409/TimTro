import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:timtro/Model/PropertyUtility.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/Model/Utility.dart';
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
        final List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
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

  Future<List<RentalProperty>> fetchTopRentalProperties() async {
    try {
      final response = await http.get(
        Uri.parse("${API.link}/rentalproperty/gettoprentalproperty"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
        json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse
            .map((property) => RentalProperty.fromJson(property))
            .toList();
      } else {
        throw Exception('Failed to load top rental properties');
      }
    } catch (e) {
      print('Error fetching top rental properties: $e');
      return [];
    }
  }

  Future<List<RentalProperty>> getRentalByLandLord(String id) async {
    try {
      final response = await http.get(
        Uri.parse("${API.link}/rentalproperty/landlord=${id}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
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

  Future<List<RentalProperty>> getRentalByUtility(String id) async {
    try {
      final response = await http.get(
        Uri.parse("${API.link}/property-utilities/utilityid=${id}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
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

  Future<List<Utility>> getUtilitiesByRental(String id) async {
    try {
      final response = await http.get(
        Uri.parse("${API.link}/property-utilities/rentalpropertyid=${id}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
        json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse
            .map((property) => Utility.fromJson(property))
            .toList();
      } else {
        throw Exception('Failed to load rental properties');
      }
    } catch (e) {
      print('Error fetching rental properties: $e');
      return [];
    }
  }



  Future<List<Utility>> getUtilities() async {
    try {
      final response = await http.get(
        Uri.parse("${API.link}/utilities"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse
            .map((property) => Utility.fromJson(property))
            .toList();
      } else {
        throw Exception('Failed to load rental properties');
      }
    } catch (e) {
      print('Error fetching rental properties: $e');
      return [];
    }
  }

  Future<RentalProperty?> postRentalProperty(RentalProperty property) async {
    try {
      final url = Uri.parse("${API.link}/rentalproperty");
      print("==========================${jsonEncode(property.toJson())}");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          // Đảm bảo thêm charset
        },
        body: jsonEncode(property.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode== 200) {
        print('Property posted successfully');
        return RentalProperty.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        print('Bad Request: ${response.body}');
      } else if (response.statusCode == 401) {
        print('Unauthorized: Please check your credentials');
      } else if (response.statusCode == 500) {
        print('Server Error: Please try again later');
      } else {
        print(
            'Failed to post property: ${response.statusCode}, ${response.body}');
      }
      return null;
    } catch (e) {
      print('Error posting property: $e');
      return null;
    }
  }

  Future<RentalProperty?> updateRentalProperty(RentalProperty property) async {
    try {
      final url = Uri.parse("${API.link}/rentalproperty/rentalpropertyid=${property.propertyId}");
      print("==========================${jsonEncode(property.toJson())}");
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          // Đảm bảo thêm charset
        },
        body: jsonEncode(property.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode== 200) {
        print('Property update successfully');
        return RentalProperty.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        print('Bad Request: ${response.body}');
      } else if (response.statusCode == 401) {
        print('Unauthorized: Please check your credentials');
      } else if (response.statusCode == 500) {
        print('Server Error: Please try again later');
      } else {
        print(
            'Failed to update property: ${response.statusCode}, ${response.body}');
      }
      return null;
    } catch (e) {
      print('Error updating property: $e');
      return null;
    }
  }


  Future<bool> postUtilityOfRentalProperty(PropertyUtility pro) async {
    try {
      print("ppppppppppppppppppppppppppppppppp${json.encode(pro.toJson())}");
      final url = Uri.parse("${API.link}/property-utilities");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          // Đảm bảo thêm charset
        },
        body: jsonEncode(pro.toJson()),
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
        print(
            'Failed to post property- utilities: ${response.statusCode}, ${response.body}');
      }
      return false;
    } catch (e) {
      print('Error posting property: $e');
      return false;
    }
  }

  Future<void> deleteRentalProperty(String id) async {
    try {
      final url =
          Uri.parse("${API.link}/rentalproperty/rentalpropertyid=${id}");
      final response = await http.delete(url);
      print("hihi");
    } catch (e) {
      print('Error posting property: $e');
    }
  }

  Future<List<RentalProperty>> getRentalByStatus(int status) async {
    try {
      final response = await http.get(
        Uri.parse("${API.link}/rentalproperty/status=${status}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print("hihi kk ${json.decode(utf8.decode(response.bodyBytes))}");
        final List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
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
  Future<bool> updateRentalStatus(String rentalpropertyId, int status) async {
    try {
      // The URL should include both rentalpropertyId and status as path parameters
      final url = Uri.parse('${API.link}/rentalproperty/rentalpropertyid=$rentalpropertyId/status/$status');

      // Sending the PATCH request with appropriate headers
      final response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print("Rental status updated successfully");
        return true; // Successfully updated the status
      } else {
        print('Failed to update rental status: ${response.statusCode}');
        return false; // Failure
      }
    } catch (e) {
      print('Error occurred while updating rental status: $e');
      return false; // Error occurred
    }
  }

  Future<List<RentalProperty>> getRentalByMonthAndYear(int month, int year) async {
    try {
      // Chuyển tháng và năm thành tham số truy vấn trong URL
      final response = await http.get(
        Uri.parse("${API.link}/rentalproperty/month=$month&year=$year"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
        json.decode(utf8.decode(response.bodyBytes));
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
}
