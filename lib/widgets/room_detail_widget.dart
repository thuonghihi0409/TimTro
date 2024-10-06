import 'package:flutter/material.dart';
import '../utils/colors.dart';

class RoomDetailWidget extends StatelessWidget {
  final List<String> productImages;
  final String roomName;
  final String price;
  final String address;
  final String time;
  final List<List<String>> priceTable;

  RoomDetailWidget({
    required this.productImages,
    required this.roomName,
    required this.price,
    required this.address,
    required this.time,
    required this.priceTable,
  });



  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    int _currentPage = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị hình ảnh sản phẩm
        Stack(
          children: [
            Container(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: productImages.length,
                onPageChanged: (index) {
                  _currentPage = index;
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    productImages[index],
                    fit: BoxFit.cover,
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
                  '${_currentPage + 1}/${productImages.length}',
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
                  if (_currentPage < productImages.length - 1) {
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
        // Thông tin phòng
        Text(
          roomName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text('Giá: $price', style: TextStyle(fontSize: 18)),
        Text(address),
        Text('Thời gian: $time'),
        SizedBox(height: 20),
        // Bảng giá
        Table(
          border: TableBorder.all(),
          children: priceTable.map((row) {
            return TableRow(children: row.map((cell) => Text(cell)).toList());
          }).toList(),
        ),
      ],
    );
  }
}
