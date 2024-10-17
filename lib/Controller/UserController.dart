import 'package:flutter/foundation.dart';
import 'package:timtro/Model/Customer.dart';
import 'package:timtro/Model/Landlork.dart';
import 'package:timtro/Model/User.dart';
import 'package:timtro/Service/UserService.dart';

class Usercontroller with ChangeNotifier {
  User? user;
  int state =0 ;
  Userservice userservice = Userservice();

  void setUser(String id) async {
    Userservice userservice = Userservice();
    user = await userservice.fetchUser(id);
    notifyListeners();
  }
  void setstate(int t){
    state=t;
    notifyListeners();
  }
  Future<void> loadState () async {
    String? temp = await userservice.getUsername();
    if (temp!=null){
      setstate(1);
    }
  }

  void logout(){
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
        ngaytao: customer.ngaytao);
    notifyListeners();
    return t;

  }
}
