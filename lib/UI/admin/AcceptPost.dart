import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/big_text.dart';
import 'package:timtro/widgets/icon_and_text_widget.dart';
import 'package:timtro/widgets/small_text.dart';

import '../User_UI/RentalpropertyUI/room_detail_page.dart';



class AcceptPost extends StatefulWidget {
  @override
  State<AcceptPost> createState() => _AcceptPostState();
}

class _AcceptPostState extends State<AcceptPost> {
  List listRental = [];

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
      final rentals = await rentalController.checkRental();
      setState(() {
        listRental = rentals;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách trọ chờ duyệt"),
      ),
      body: Container(
        child: listRental.isNotEmpty
            ? ListView.builder(
                itemCount: listRental.length,
                itemBuilder: (context, index) {
                  return Item(index);
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Không có trọ cần duyệt',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
    );
  }

  Widget Item(int index) {
    final formatter = NumberFormat('#,##0');

    final rentPrice = listRental[index].rentPrice is String
        ? int.tryParse(listRental[index].rentPrice) ?? 0
        : listRental[index].rentPrice;

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.close, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        String action =
            direction == DismissDirection.startToEnd ? "duyệt" : "từ chối";
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Xác nhận $action bài đăng"),
              content:
                  Text("Bạn có chắc chắn muốn $action bài đăng này không?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Hủy hành động
                  },
                  child: Text("Không"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Xác nhận hành động
                  },
                  child: Text("Có"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Duyệt bài đăng
          await context
              .read<Rentalpropertycontroller>()
              .approveRental(listRental[index].propertyId);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${listRental[index].propertyName} đã được duyệt"),
          ));
        } else if (direction == DismissDirection.endToStart) {
          // Từ chối bài đăng
          await context
              .read<Rentalpropertycontroller>()
              .rejectRental(listRental[index].propertyId);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${listRental[index].propertyName} đã bị từ chối"),
          ));
        }

        // Cập nhật danh sách sau khi duyệt/từ chối
        setState(() {
          listRental.removeAt(index);
        });
      },
      child: GestureDetector(
        onTap: () {
          // Navigate to the rental property detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RoomDetailPage(rentalProperty: listRental[index]),
            ),
          );
        },
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
                      ? Image.network(
                          listRental[index].images[0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(child: Text('Error loading image'));
                          },
                        )
                      : Center(child: Text('No Image')),
                ),
              ),
              Expanded(
                child: Container(
                  height: 150,
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
                            BigText(text: "${listRental[index].propertyName}"),
                          ],
                        ),
                        SizedBox(height: 1),
                        SmallText(
                            text: "Giá: ${formatter.format(rentPrice)} VNĐ"),
                        SizedBox(height: 2),
                        SmallText(
                            text:
                                "Số phòng còn: ${listRental[index].availableRooms}"),
                        SizedBox(height: 2),
                        SmallText(
                            text:
                                "Ngày đăng: ${listRental[index].postDate.toLocal().toString().split(' ')[0]}"),
                        SizedBox(height: 5),
                        if (listRental[index].status == 1)
                          Text("Đang chờ duyệt"),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
