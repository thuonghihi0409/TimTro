import 'package:flutter/cupertino.dart';

// import '../Model/User.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Controller/RentalPropertyController.dart';
import '../../Model/RentelProperty.dart';
import '../../Model/User.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/small_text.dart';
import '../User_UI/RentalpropertyUI/room_detail_page.dart';
//
// import '../Controller/RentalPropertyController.dart';
// import '../Model/RentelProperty.dart';
//
// import '../UI/RentalpropertyUI/room_detail_page.dart';
// import '../utils/colors.dart';
// import '../widgets/big_text.dart';
// import '../widgets/icon_and_text_widget.dart';
// import '../widgets/small_text.dart';


class RentalListPage extends StatefulWidget {
  final String userId; // Truyền userId để lấy danh sách bất động sản

  RentalListPage({required this.userId, required User user});

  @override
  _RentalListPageState createState() => _RentalListPageState();
}

class _RentalListPageState extends State<RentalListPage> {
  List<RentalProperty> rentalList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRentalProperties();
    });
  }


  Future<void> _loadRentalProperties() async {
    final rentalController = context.read<Rentalpropertycontroller>();
    try {
      // Gọi hàm getRentalByLandLord để lấy danh sách bất động sản của người dùng
      final List<RentalProperty> properties = await rentalController.getRentalByLandLord(widget.userId);
      setState(() {
        rentalList = properties;
        isLoading = false; // Dừng trạng thái loading sau khi hoàn thành
      });
    } catch (error) {
      print('Error loading rental properties: $error');
      setState(() {
        isLoading = false; // Dừng trạng thái loading ngay cả khi có lỗi
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sach tro"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị spinner khi đang tải
          : rentalList.isEmpty
          ? Center(child: Text("Khong co tro")) // Hiển thị khi không có dữ liệu
          : ListView.builder(
        itemCount: rentalList.length,
        itemBuilder: (context, index) {
          final property = rentalList[index];
          return Item(
            rentalProperty: property,
            onDelete: () async {
              try {
                // Lấy controller từ context
                final rentalController = context.read<Rentalpropertycontroller>();

                // Gọi hàm deleteRental từ controller để xóa bất động sản trong cơ sở dữ liệu
                await rentalController.deleteRental(property.propertyId);
                print("kkkkkkkkkkkk"+ property.propertyId);

                // Cập nhật lại giao diện để loại bỏ mục đã xóa
                setState(() {
                  rentalList.removeAt(index); // Xóa mục khỏi danh sách trên giao diện
                });

                // Hiển thị thông báo thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Xóa thành công!')),
                );
              } catch (error) {
                // Hiển thị thông báo nếu có lỗi xảy ra khi xóa
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Xóa thất bại: $error')),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class Item extends StatefulWidget {
  final RentalProperty rentalProperty;
  final Function onDelete; // Thêm callback để xóa bất động sản

  Item({super.key, required this.rentalProperty, required this.onDelete});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');

    final rentPrice = widget.rentalProperty.rentPrice is String
        ? int.parse(widget.rentalProperty.rentPrice)
        : widget.rentalProperty.rentPrice ?? 0;

    List<Map<String, dynamic>> iconData = [
      {'icon': Icons.star, 'text': "4.5", 'iconColor': AppColors.inconColor1},
      {'icon': Icons.location_on, 'text': "1.7km", 'iconColor': AppColors.mainColor},
      {'icon': Icons.access_time_rounded, 'text': "32min", 'iconColor': AppColors.inconColor2},
    ];

    return Dismissible(
        key: Key(widget.rentalProperty.propertyId),
        // Chỉ cho phép vuốt sang trái
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red, // Màu nền khi vuốt qua trái
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.delete, color: Colors.white), // Icon xóa
        ),
        onDismissed: (direction) {
          // Xử lý khi vuốt qua trái để xóa
          widget.onDelete();
        },
        confirmDismiss: (direction) async {
          // Chỉ cần xử lý xác nhận xóa khi vuốt sang trái
          return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Xác nhận"),
                content: Text("Bạn có chắc chắn muốn xóa bất động sản này?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Hủy"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Xóa"),
                  ),
                ],
              );
            },
          );
        },
        child: InkWell(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white38,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: widget.rentalProperty.images.isNotEmpty
                        ? Image.network(widget.rentalProperty.images[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text('Error loading image'));
                        })
                        : Center(child: Text('No Image')),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigText(text: "${widget.rentalProperty.propertyName}"),
                          SizedBox(height: 5),
                          SmallText(
                              text: "Giá: ${formatter.format(rentPrice)} VNĐ"),
                          // Sử dụng formatter
                          SizedBox(height: 5),
                          SmallText(
                              text:
                              "Số phòng còn: ${widget.rentalProperty.availableRooms}"),
                          SizedBox(height: 5),
                          SmallText(
                              text:
                              "Ngày đăng: ${widget.rentalProperty.postDate.toLocal().toString().split(' ')[0]}"),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: iconData.map((data) => IconAndTextWidget(
                                icon: data['icon'],
                                text: data['text'],
                                iconColor: data['iconColor']
                            )).toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RoomDetailPage(rentalProperty: widget.rentalProperty)),
            );
          },
        )
    );
  }
}
