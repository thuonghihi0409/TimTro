import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
class RentalMapScreen extends StatelessWidget {
  final List<Map<String, dynamic>> rentalLocations = [
    {"name": "Trọ A", "lat": 10.8231, "lng": 106.6297},
    {"name": "Trọ B", "lat": 10.762622, "lng": 106.660172},
    {"name": "Trọ C", "lat": 10.7769, "lng": 106.7009},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bản đồ tìm trọ")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(10.8231, 106.6297),
              zoom: 13.0,
            ),
            children: [
              // Lớp bản đồ nền từ OpenStreetMap
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              // Lớp để hiển thị các điểm đánh dấu
              MarkerLayer(
                markers: rentalLocations.map((location) {
                  return Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(location["lat"], location["lng"]),
                    builder: (ctx) => GestureDetector(
                      onTap: () {
                        showDialog(
                          context: ctx,
                          builder: (_) => AlertDialog(
                            title: Text(location["name"]),
                            content: Text("Vị trí: ${location["lat"]}, ${location["lng"]}"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: Text("Đóng"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // Ghi chú về bản quyền
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white.withOpacity(0.7),
              child: Text(
                "© OpenStreetMap contributors",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






class MapScreen extends StatefulWidget {
  final Function(String) onLocationSelected;

  MapScreen({required this.onLocationSelected});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _selectedPosition;
  String _address = '';

  Future<void> _getAddress(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    setState(() {
      _address = '${placemarks.first.street}, ${placemarks.first.locality}';
    });
  }

  void _onTap(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
    _getAddress(position);
  }

  void _selectLocation() {
    if (_selectedPosition != null) {
      widget.onLocationSelected(_address);
      Navigator.pop(context);
    }
  }

  Future<List<String>> _getPlaceSuggestions(String query) async {
    String apiKey = 'pk.eyJ1IjoidmFudGh1b25naGloaTA0MDkiLCJhIjoiY20yenM4YWlpMGYxaTJqcTB3bzVnN2Z5MSJ9.r_qlCGyNIjv2PO2H0tvgjQ'; // Thay thế bằng API Key của bạn
    String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> features = jsonResponse['features'];

      // Lấy tên địa điểm từ kết quả
      return features.map((item) => item['place_name'] as String).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn vị trí'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _selectLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TypeAheadField<String>(
              suggestionsCallback: (pattern) async {
                return await _getPlaceSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (suggestion) async {
                // Khi người dùng chọn một địa điểm từ gợi ý
                List<Location> locations = await locationFromAddress(suggestion);
                if (locations.isNotEmpty) {
                  final selectedLatLng = LatLng(locations.first.latitude, locations.first.longitude);

                  // Di chuyển đến tọa độ của địa điểm tìm được và cập nhật bản đồ
                  setState(() {
                    _selectedPosition = selectedLatLng;
                    _address = suggestion;
                  });
                  _mapController.move(selectedLatLng, 15.0);
                }
              },
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm địa điểm',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(10.8231, 106.6297),
                zoom: 12.0,
                onTap: _onTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                if (_selectedPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _selectedPosition!,
                        builder: (ctx) => Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
