import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/UI/RentalpropertyUI/room_detail_page.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/big_text.dart';
import 'package:timtro/widgets/icon_and_text_widget.dart';
import 'package:timtro/widgets/small_text.dart';

class MyRental extends StatefulWidget {

  @override
  State<MyRental> createState() => _MyRentalState();
}

class _MyRentalState extends State<MyRental> {
  List<RentalProperty> listRental = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRentalProperties();
    });
  }

  Future<void> _loadRentalProperties() async {
    final rentalController = context.read<Rentalpropertycontroller>();
    final userController = context.read<Usercontroller>();

    // Kiểm tra user trước khi lấy danh sách bất động sản
    if (userController.user != null) {
      final rentals =
      await rentalController.getRentalByLandLord(userController.user!.id);
      setState(() {
        listRental = rentals;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý bài đăng"),
      ),
      body: Container(
        child: listRental.isNotEmpty
            ? ListView.builder(
          itemCount: listRental.length,
          itemBuilder: (context, index) {
            return Item( index);
          },
        )
            : Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Chưa có bất động sản nào.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget Item (int index){
    final formatter =
    NumberFormat('#,##0'); // Định dạng giá với dấu phân cách ngàn
    // Chuyển đổi rentPrice sang kiểu num nếu cần
    final rentPrice = listRental[index].rentPrice is String
        ? int.tryParse(listRental[index].rentPrice) ?? 0
        : listRental[index].rentPrice;
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white38,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: listRental[index].images.isNotEmpty
                    ? Image.network(listRental[index].images[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Error loading image'));
                    })
                    : Center(child: Text('No Image')),
              ),
            ),
            Expanded(
              child: Container(
                height: 140,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BigText(
                              text:
                              "${listRental[index].propertyName}"),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  _editRental(index);
                                  break;
                                case 'delete':
                                  _deleteRental(index);
                                  break;
                                case 'hide':
                                  _hideRental(index);
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Chỉnh sửa'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Xóa'),
                              ),
                              PopupMenuItem(
                                value: 'hide',
                                child: Text('Ẩn'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      SmallText(
                          text: "Giá: ${formatter.format(rentPrice)} VNĐ"),
                      SizedBox(height: 5),
                      SmallText(
                          text:
                          "Số phòng còn: ${listRental[index].availableRooms}"),
                      SizedBox(height: 5),
                      SmallText(
                          text:
                          "Ngày đăng: ${listRental[index].postDate.toLocal().toString().split(' ')[0]}"),
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
          MaterialPageRoute(
              builder: (context) => RoomDetailPage(
                  rentalProperty: listRental[index])),
        );
      },
    );
  }


  void _editRental(int index) {
    // Logic để chỉnh sửa rental
    print("Chỉnh sửa: ${listRental[index].propertyName}");
  }

  Future<void> _deleteRental(int index) async {
    final rentalController = context.read<Rentalpropertycontroller>();
    await rentalController
        .deleteRental(listRental[index].propertyId);
    setState(() {
      listRental.removeAt(index);
    });
  }

  void _hideRental(int index) {
    // Logic để ẩn rental
    print("Ẩn: ${listRental[index].propertyName}");
  }
}



class Item extends StatefulWidget {
  final List<RentalProperty> listRental;
  final int index;

  Item({super.key, required this.listRental, required this.index});

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    // Khởi tạo NumberFormat với định dạng cho tiền tệ
    final formatter =
    NumberFormat('#,##0'); // Định dạng giá với dấu phân cách ngàn
    // Chuyển đổi rentPrice sang kiểu num nếu cần
    final rentPrice = widget.listRental[widget.index].rentPrice is String
        ? int.tryParse(widget.listRental[widget.index].rentPrice) ?? 0
        : widget.listRental[widget.index].rentPrice;
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white38,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.listRental[widget.index].images.isNotEmpty
                    ? Image.network(widget.listRental[widget.index].images[0],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Error loading image'));
                    })
                    : Center(child: Text('No Image')),
              ),
            ),
            Expanded(
              child: Container(
                height: 140,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BigText(
                              text:
                              "${widget.listRental[widget.index].propertyName}"),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  _editRental();
                                  break;
                                case 'delete':
                                  _deleteRental();
                                  break;
                                case 'hide':
                                  _hideRental();
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Chỉnh sửa'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Xóa'),
                              ),
                              PopupMenuItem(
                                value: 'hide',
                                child: Text('Ẩn'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      SmallText(
                          text: "Giá: ${formatter.format(rentPrice)} VNĐ"),
                      SizedBox(height: 5),
                      SmallText(
                          text:
                          "Số phòng còn: ${widget.listRental[widget.index].availableRooms}"),
                      SizedBox(height: 5),
                      SmallText(
                          text:
                          "Ngày đăng: ${widget.listRental[widget.index].postDate.toLocal().toString().split(' ')[0]}"),
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
          MaterialPageRoute(
              builder: (context) => RoomDetailPage(
                  rentalProperty: widget.listRental[widget.index])),
        );
      },
    );
  }

  void _editRental() {
    // Logic để chỉnh sửa rental
    print("Chỉnh sửa: ${widget.listRental[widget.index].propertyName}");
  }

  Future<void> _deleteRental() async {
    final rentalController = context.read<Rentalpropertycontroller>();
    await rentalController
        .deleteRental(widget.listRental[widget.index].propertyId);
    setState(() {
      widget.listRental.removeAt(widget.index);
    });
  }

  void _hideRental() {
    // Logic để ẩn rental
    print("Ẩn: ${widget.listRental[widget.index].propertyName}");
  }
}