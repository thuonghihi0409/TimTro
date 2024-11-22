import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timtro/Controller/UserController.dart';
import 'package:timtro/Model/User.dart';
import 'package:timtro/utils/colors.dart';
import 'package:timtro/widgets/search.dart';

import 'RentalListPage.dart';

class UserManager extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<UserManager> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    final userController = context.read<Usercontroller>();
    userController.loadAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userController = context.watch<Usercontroller>();

    if (userController.users.isEmpty) {
      return SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_search,
                size: 100,
                color: AppColors.mainColor.withOpacity(0.5),
              ),
              SizedBox(height: 16),
              Text(
                "Không có người dùng",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final filteredUsers = userController.users.where((user) {
      return user.vaitro != "admin" &&
          user.username.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text("Quản lý người dùng"),
              backgroundColor: AppColors.mainColor,
              elevation: 0,
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: SearchWidget(
                  onSearch: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                ),
              ),
            ),
            filteredUsers.isEmpty
                ? SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Không tìm thấy người dùng",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final user = filteredUsers[index];
                  return UserItem(user: user);
                },
                childCount: filteredUsers.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class UserItem extends StatelessWidget {
  final User user;

  const UserItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: user.avturl.isEmpty ? AppColors.mainColor : null,
          // backgroundImage: user.avturl.isNotEmpty
          //     ? NetworkImage(user.avturl)
          //     : null,
          backgroundImage: (user.avturl.isNotEmpty &&
              Uri.tryParse(user.avturl)?.hasAbsolutePath == true &&
              !user.avturl.contains(' '))
              ? NetworkImage(user.avturl)
              : null,
          child: user.avturl.isEmpty
              ? Text(
            user.name.isNotEmpty
                ? user.name[0].toUpperCase()
                : user.username[0].toUpperCase(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )
              : null,
        ),
        title: Text(
          user.name.isNotEmpty ? user.name : user.username,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          user.gmail,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(context),
        ),
        onTap: () => _showUserDetails(context),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa"),
          content: Text("Bạn có chắc muốn xóa ${user.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                final userController = context.read<Usercontroller>();
                userController.deleteUser(user.id!);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Đã xóa ${user.name}"),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  void _showUserDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailPage(user: user),
      ),
    );
  }
}

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                user.name.isNotEmpty ? user.name : user.username,
                style: TextStyle(color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  user.avturl.isNotEmpty
                      ? Image.network(
                    user.avturl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildAvatarPlaceholder();
                    },
                  )
                      : _buildAvatarPlaceholder(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildDetailItem(Icons.email, "Email", user.gmail),
                _buildDetailItem(Icons.tag, "Vai trò", user.vaitro),
                SizedBox(height: 24),
                _buildActionButtons(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: AppColors.mainColor,
      child: Center(
        child: Text(
          user.name.isNotEmpty
              ? user.name[0].toUpperCase()
              : user.username[0].toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 100,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.mainColor),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: Icons.home,
          label: "Danh sách trọ",
          color: AppColors.mainColor,
          onPressed: () {
            // Implement add functionality
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RentalListPage(
                  userId: user.id, // Truyền userId vào RentalListPage
                  user: user,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

}