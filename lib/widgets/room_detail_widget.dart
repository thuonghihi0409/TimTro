import 'package:flutter/material.dart';
import 'package:timtro/Model/RentelProperty.dart';
import '../utils/colors.dart';

class RoomDetailWidget extends StatelessWidget {
  final RentalProperty rentalProperty;

  RoomDetailWidget({
    required this.rentalProperty,
  });

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    int _currentPage = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị hình ảnh sản phẩm từ URL
        Stack(
          children: [
            Container(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 1, // Giả sử bạn chỉ có 1 ảnh cho mỗi phòng
                onPageChanged: (index) {
                  _currentPage = index;
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    rentalProperty.image, // URL hình ảnh từ rentalProperty
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Failed to load image'));
                    },
                  );
                },
              ),
            ),
            // Hiển thị số đếm
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.black54,
                child: Text(
                  '${_currentPage + 1}/1', // Hiện 1 ảnh nên tổng là 1
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            // Mũi tên sang trái
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  if (_currentPage > 0) {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            // Mũi tên sang phải
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  if (_currentPage < 1 - 1) { // 1 ảnh duy nhất
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        // Thông tin phòng từ rentalProperty
        Text(
          rentalProperty.propertyName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text('Giá: ${rentalProperty.rentPrice}', style: TextStyle(fontSize: 18)),
        Text(rentalProperty.address),
        Text('Diện tích: ${rentalProperty.area} m²'),
        SizedBox(height: 20),
        // Bảng giá từ thuộc tính riêng của phòng
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: ['Điện', 'Nước', 'Xe', 'Quản lý']
                  .map((title) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              ))
                  .toList(),
            ),
            TableRow(
              children: ['3.800/kWh', '80.000/ng', '80.000/xe', '0/ph']
                  .map((value) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(value),
              ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}
