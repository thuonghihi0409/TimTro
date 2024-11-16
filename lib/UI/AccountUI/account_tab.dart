import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/RentalPropertyController.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/UI/AccountUI/LoginPage.dart';
import 'package:timtro/UI/RentalpropertyUI/UploadImage.dart';
import 'package:timtro/UI/RentalpropertyUI/find_tab.dart';
import 'package:timtro/UI/AccountUI/info_customer.dart';
import 'package:timtro/UI/RentalpropertyUI/room_detail_page.dart';
import 'package:timtro/UI/RentalpropertyUI/upRentalpropertyscreen.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/big_text.dart';
import 'package:timtro/widgets/icon_and_text_widget.dart';
import 'package:timtro/widgets/small_text.dart';
import '../../Model/RentelProperty.dart';
import 'RegisterPage.dart';

class AccountTab1 extends StatelessWidget {
  const AccountTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final usercontroller = context.watch<Usercontroller>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.mainColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Tài khoản khách',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView(
            children: [
              _buildListTile(
                context,
                icon: Icons.person_add,
                title: 'Đăng ký',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildListTile(
                context,
                icon: Icons.login,
                title: 'Đăng nhập',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildListTile(
                context,
                icon: Icons.info_rounded,
                title: 'Về chúng tôi',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color iconColor = AppColors.mainColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[300]);
  }
}

void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Về chúng tôi'),
        content: const Text('Nội dung về chúng tôi...'),
        actions: [
          TextButton(
            child: const Text('Đóng'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//=============================================================

class AccountTab2 extends StatefulWidget {
  const AccountTab2({super.key});

  @override
  State<AccountTab2> createState() => _AccountTab2State();
}

class _AccountTab2State extends State<AccountTab2> {
  List<RentalProperty> listRental = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRentalProperties();
    });
  }

  Future<void> _loadRentalProperties() async {
    final rentalController =  context.read<Rentalpropertycontroller>();
    final userController = context.read<Usercontroller>();

    // Kiểm tra user trước khi lấy danh sách bất động sản
    if (userController.user != null) {
      final rentals = await rentalController.getRentalByLandLord(userController.user!.id);
      setState(() {
        listRental = rentals;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final usercontroller = context.watch<Usercontroller>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: AppColors.mainColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${usercontroller.user?.name}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Cài đặt tài khoản',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildListTile(
                    context,
                    icon: Icons.person_add,
                    title: 'Thông tin cá nhân',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerInfoPage(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon: Icons.login,
                    title: 'Đăng trọ',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadRentalPropertyScreen(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon: Icons.info,
                    title: 'Về chúng tôi',
                    onTap: () => _showAboutDialog(context),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    onTap: () => _showLogoutConfirmation(context, usercontroller),
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (listRental.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: listRental.length,
                  itemBuilder: (context, index) {
                    final rentalProperty = listRental[index];
                    return Item(rentalProperty: rentalProperty);
                  },
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Chưa có bất động sản nào.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color iconColor = AppColors.mainColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey[300]);
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
              height: 130,
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
                          BigText(text: "${widget.rentalProperty.propertyName}"),
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
                      SmallText(text: "Giá: ${formatter.format(rentPrice)} VNĐ"),
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

  void _editRental() {
    // Logic để chỉnh sửa rental
    print("Chỉnh sửa: ${widget.rentalProperty.propertyName}");
  }

  void _deleteRental() {
    // Logic để xóa rental
    print("Xóa: ${widget.rentalProperty.propertyName}");
  }

  void _hideRental() {
    // Logic để ẩn rental
    print("Ẩn: ${widget.rentalProperty.propertyName}");
  }
}


//=============================================================

void _showLogoutConfirmation(BuildContext context, Usercontroller usercontroller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            onPressed: () {
              usercontroller.logout();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

