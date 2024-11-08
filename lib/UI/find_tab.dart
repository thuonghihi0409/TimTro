import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/UI/room_detail_page.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/big_text.dart';
import 'package:timtro/widgets/small_text.dart';
import '../widgets/icon_and_text_widget.dart';
import '../widgets/search.dart';
import 'package:intl/intl.dart';  // Thêm dòng này

class FindTab extends StatefulWidget {
  @override
  _FindTabState createState() => _FindTabState();
}

class _FindTabState extends State<FindTab> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    final rentalController = context.read<Rentalpropertycontroller>();
    rentalController.setRental(); // Gọi loadState một lần khi widget được khởi tạo
  }

  @override
  Widget build(BuildContext context) {
    final rentalpropertycontroller = context.watch<Rentalpropertycontroller>();
    final filteredList = rentalpropertycontroller.listRental
        .where((property) => property.propertyName
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))
        .toList();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: SearchWidget(
                onSearch: (query) {
                  setState(() {
                    searchQuery = query; // Cập nhật truy vấn tìm kiếm
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final toElement = filteredList[index]; // Lấy phần tử dựa trên index
                  return Item(rentalProperty: toElement); // Trả về widget Item
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class Item extends StatefulWidget {
  final RentalProperty rentalProperty;

  Item({super.key, required this.rentalProperty});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    // Khởi tạo NumberFormat với định dạng cho tiền tệ
    final formatter = NumberFormat('#,##0'); // Định dạng giá với dấu phân cách ngàn

    // Chuyển đổi rentPrice sang kiểu num nếu cần
    final rentPrice = widget.rentalProperty.rentPrice is String
        ? int.tryParse(widget.rentalProperty.rentPrice) ?? 0
        : widget.rentalProperty.rentPrice;

    return InkWell(
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
                child: widget.rentalProperty.image.isNotEmpty
                    ? Image.network(widget.rentalProperty.image,
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
                      SmallText(text: "Giá: ${formatter.format(rentPrice)} VNĐ"), // Sử dụng formatter
                      SizedBox(height: 5),
                      SmallText(text: "Số phòng còn: ${widget.rentalProperty.availableRooms}"),
                      SizedBox(height: 5),
                      SmallText(text: "Ngày đăng: ${widget.rentalProperty.postDate.toLocal().toString().split(' ')[0]}"),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconAndTextWidget(
                            icon: Icons.star,
                            text: "4.5",
                            iconColor: AppColors.inconColor1,
                          ),
                          IconAndTextWidget(
                            icon: Icons.location_on,
                            text: "1.7km",
                            iconColor: AppColors.mainColor,
                          ),
                          IconAndTextWidget(
                            icon: Icons.access_time_rounded,
                            text: "32min",
                            iconColor: AppColors.inconColor2,
                          )
                        ],
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
          MaterialPageRoute(builder: (context) => RoomDetailPage(rentalProperty: widget.rentalProperty)),
        );
      },
    );
  }
}