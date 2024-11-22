import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Mapservice{
  late double latitude;
  late double longitude;
  Future<String> getGoogleMapsLink() async {
    final String url = 'https://www.google.com/maps?q=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
     // await launchUrl(Uri.parse(url));
      return url;
    } else {
      throw 'Could not launch $url';
      return "";
    }
  }

  Future<String> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ vị trí có bật không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí đang bị tắt.');
    }

    // Kiểm tra quyền và yêu cầu quyền nếu cần
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Quyền vị trí đã bị từ chối.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Quyền vị trí bị từ chối vĩnh viễn. Không thể yêu cầu quyền.');
    }

    // Lấy vị trí hiện tại
     Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
     );
     longitude=position.longitude;
     latitude=position.latitude;

    try {
      // Lấy danh sách các Placemark từ tọa độ
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      // Chọn thông tin của Placemark đầu tiên
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
          return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      } else {
        return "khong lay duoc vi tri";
      }
    } catch (e) {
      return "Loi lay vi tri";
    }
  }

  String extractCoordinatesWithAddress(String url) {
    try {
      Uri uri = Uri.parse(url);
      String? address;

      // Kiểm tra tọa độ trong pathSegments
      if (uri.pathSegments.isNotEmpty) {
        String lastSegment = uri.pathSegments.last;
        if (lastSegment.contains(',')) {
          List<String> coordinates = lastSegment.split(',');
          latitude = double.tryParse(coordinates[0])!;
          longitude = double.tryParse(coordinates[1])!;
        }
      }

      // Kiểm tra địa chỉ và tọa độ trong query parameter "q"
      if (uri.queryParameters.containsKey('q')) {
        String query = uri.queryParameters['q']!;
        if (query.contains(',')) {
          List<String> parts = query.split(',');
          latitude ??= double.tryParse(parts[0])!;
          longitude ??= double.tryParse(parts[1])!;
          // Lấy phần địa chỉ nếu có
          if (parts.length > 2) {
            address = parts.sublist(2).join(',').trim();
          }
        } else {
          address = query; // Nếu không có tọa độ, chỉ lấy địa chỉ
        }
      }

      // Kết quả trả về
      if (latitude != null && longitude != null) {
        String result = 'Latitude: $latitude, Longitude: $longitude';
        if (address != null) {
          result +=  "$address";
        }
        return result;
      }

      return 'Không tìm thấy tọa độ hoặc địa chỉ trong URL.';
    } catch (e) {
      return 'Lỗi khi phân tích URL: $e';
    }
  }

}
