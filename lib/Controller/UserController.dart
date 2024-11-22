import 'package:flutter/foundation.dart';
import 'package:timtro/Model/Customer.dart';
import 'package:timtro/Model/Landlork.dart';
import 'package:timtro/Model/User.dart';
import 'package:timtro/Service/UserService.dart';

class Usercontroller with ChangeNotifier {
  User? user;
  int state = 0;

  Userservice userservice = Userservice();
void loadUI(){
  notifyListeners();
}
  // void setUser(String id) async {
  //
  //   user = await userservice.fetchUser(id);
  //   print("${user!.username} hi");
  //   notifyListeners();
  // }
  void setstate(int t) {
    state = t;
    notifyListeners();
  }

  Future<void> loadState() async {
    String? temp = await userservice.getUsername();
    if (temp != null) {
      userservice.fetchUser(temp);
      user = await userservice.fetchUser(temp);
      setstate(1);
    }
  }

  void logout() {
    userservice.removeUsername();
    setstate(0);
  }

  Future<int> createCustomer(Customer customer) async {
    int t = await userservice.saveCustomerToAPI(customer);
    // if (t == 200) {
    //   user = customer;
    // }
    await userservice.saveUsername(customer.username);
    user = User(
        id: customer.id,
        username: customer.username,
        password: customer.password,
        name: customer.name,
        sdt: customer.sdt,
        gmail: customer.gmail,
        vaitro: customer.vaitro,
        ngaytao: customer.ngaytao,
        avturl: " ",
    );
    notifyListeners();
    return t;
  }

  Future<int> updateUser(User user) async {
     return await userservice.updateUserToAPI(user);
  }

  Future<void> login(User user1) async {
    user = await userservice.login(user1);

    if (user != null) {
      setstate(1);
      await userservice.saveUsername(user!.username);
    }
  }

  List<User> users = []; // Danh sách người dùng với kiểu User


  Future<void> loadAllUsers() async {
    try {
      users = await userservice.fetchAllUsers();
      debugPrint("Loaded ${users.length} users successfully.");
      notifyListeners();
    } catch (error) {
      debugPrint("Error loading users: $error");
      // Bạn cũng có thể thông báo lỗi qua giao diện nếu cần.
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      bool isDeleted = await userservice.deleteUser(userId); // Gọi service xóa
      if (isDeleted) {
        users.removeWhere((user) => user.id == userId); // Xóa khỏi danh sách
        notifyListeners();
        debugPrint("Deleted user with ID: $userId");
      } else {
        debugPrint("Failed to delete user with ID: $userId");
      }
    } catch (error) {
      debugPrint("Error deleting user: $error");
      // Bạn có thể hiển thị thông báo lỗi trong UI nếu cần.
    }
  }
}
