import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tìm phòng giá tốt tại đây'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.blue,
              child: Column(
                children: [
                  Text(
                    'ỨNG DỤNG TÌM TRỌ DUY NHẤT HIỆN NAY',
                    style: TextStyle(color: Colors.white),
                  ),
                  // Add more widgets here to complete the banner
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Xu hướng tìm kiếm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  // Each button can be a Column containing an Icon and Text
                  buildIconButton('Phòng trọ sinh viên', Icons.house),
                  buildIconButton('Phòng trọ có gác', Icons.stairs),
                  buildIconButton('Phòng trọ giá rẻ', Icons.attach_money),
                  buildIconButton('Nuôi thú cưng', Icons.pets),
                  buildIconButton('Có ban công', Icons.balcony),
                  buildIconButton('Phòng trọ theo quận', Icons.location_on),
                  buildIconButton('Căn hộ dịch vụ', Icons.hotel),
                  buildIconButton('Cho người nước ngoài', Icons.people),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Nhắn tin',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Tìm phòng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Thông báo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Tài khoản',
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  Column buildIconButton(String text, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        SizedBox(height: 8),
        Text(text, textAlign: TextAlign.center),
      ],
    );
  }
}
