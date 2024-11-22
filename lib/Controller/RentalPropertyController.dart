import 'dart:async';

import 'package:timtro/Model/PropertyUtility.dart';
import 'package:timtro/Model/RentelProperty.dart';
import 'package:timtro/Model/Utility.dart';
import 'package:timtro/Service/RentalpropertyService.dart';
import 'package:flutter/foundation.dart';

class Rentalpropertycontroller with ChangeNotifier{
  String? select="";
  List listRental =[];

  Rentalpropertyservice rentalPropertyservice= Rentalpropertyservice();
  void uploadUI (){
    notifyListeners();
  }
  void setSelect(String? str){
    select=str;
  }
   void setRental () async {
     if(select=="") listRental= await rentalPropertyservice.getRentalByStatus(0) as List;
     else listRental= await rentalPropertyservice.getRentalByUtility(select!) as List;
    uploadUI();
  }

  Future<List<RentalProperty>> getTopRental () async {
     return await rentalPropertyservice.fetchTopRentalProperties();
  }


  Future<void> postRental(RentalProperty rental, List<Utility> list) async {
    // Tạo Completer để quản lý quá trình chờ đợi
    Completer<RentalProperty> completer = Completer<RentalProperty>();

    try {
      // Gọi API để tạo rental
      RentalProperty? createdRental = await rentalPropertyservice.postRentalProperty(rental);

      // Kiểm tra nếu rental được tạo thành công
      if (createdRental != null) {
        completer.complete(createdRental); // Hoàn tất Completer
      } else {
        completer.completeError("Không tạo được rental");
        return;
      }

      // Chờ đến khi Completer hoàn thành
      RentalProperty rentalProperty = await completer.future;

      print("Rental đã được tạo với ID: ${rentalProperty.propertyName}");

      // Đăng lần lượt từng Utility
      for (Utility utility in list) {
        PropertyUtility propertyUtility = PropertyUtility(
          propertyUtilityId: "kokoko",
          rentalProperty: rentalProperty,
          utility: utility,
        );

        bool isSuccess = await rentalPropertyservice.postUtilityOfRentalProperty(propertyUtility);

        if (isSuccess) {
          print("Utility ${utility.utilityName} đã được lưu thành công");
        } else {
          print("Không thể lưu Utility ${utility.utilityName}");
           // Nếu gặp lỗi thì dừng lại
        }
      }
      // Sau khi hoàn thành, cập nhật giao diện
      uploadUI();

    } catch (e) {
      print("Lỗi xảy ra: $e");
    }
  }
Future<void> updateRental(RentalProperty rental) async {
    await rentalPropertyservice.updateRentalProperty(rental);
}

  Future<List<RentalProperty>> getRentalByLandLord (String id) async{
    uploadUI();
    return await rentalPropertyservice.getRentalByLandLord(id);
  }

  Future<List<RentalProperty>> getRentalByUtility (String id) async{

    return await rentalPropertyservice.getRentalByUtility(id);
  }
  Future<List<Utility>> getUtilities () async{

    return await rentalPropertyservice.getUtilities();
  }

  Future<List<Utility>> getUtilitiesByRental (String id) async{
    return await rentalPropertyservice.getUtilitiesByRental(id);
    uploadUI();
  }

  Future<void> deleteRental (String id)async {
    await rentalPropertyservice.deleteRentalProperty(id);
    uploadUI();
  }

  // Function to reject a rental property by setting its status to 0
  Future<void> rejectRental(String propertyId) async {
    bool success = await rentalPropertyservice.updateRentalStatus(propertyId, -1);
    if (success) {
      // Optionally, update the local list or UI after status change
      uploadUI();
    } else {
      print("Failed to reject the rental property.");
    }
  }

  // Function to approve a rental property (set status to 1)
  Future<void> approveRental(String propertyId) async {
    bool success = await rentalPropertyservice.updateRentalStatus(propertyId, 0);
    if (success) {
      // Optionally, update the local list or UI after status change
      uploadUI();
    } else {
      print("Failed to approve the rental property.");
    }
  }


  // Future<Map<int, int>> getRentalCountForYear(int year) async {
  //   try {
  //     // Tạo một Map để lưu dữ liệu với key là tháng, value là số lượng phòng
  //     Map<int, int> rentalCountPerMonth = {};
  //
  //     for (int month = 1; month <= 12; month++) {
  //       // Gọi hàm service để lấy danh sách phòng cho từng tháng
  //       List<RentalProperty> rentals = await rentalPropertyservice.getRentalByMonthAndYear(month, year);
  //
  //       // Cập nhật số lượng phòng cho tháng tương ứng
  //       rentalCountPerMonth[month] = rentals.length;
  //     }
  //
  //     return rentalCountPerMonth;
  //   } catch (e) {
  //     print('Error fetching rental count for year: $e');
  //     return {};
  //   }
  // }

  Future<Map<int, int>> getRentalCountForYear(int year) async {
    try {
      // Map to store rental counts for each month
      Map<int, int> rentalCountPerMonth = {};

      // Loop over each month of the year
      for (int month = 1; month <= 12; month++) {
        // Fetch the rentals for the current month and year
        List<RentalProperty> rentals = await rentalPropertyservice.getRentalByMonthAndYear(month, year);

        // Filter rentals by status 0 (available) if needed
        List<RentalProperty> availableRentals = rentals.where((rental) => rental.status == 0).toList();

        // Update the map with the count of available rentals for the current month
        rentalCountPerMonth[month] = availableRentals.length;
      }

      return rentalCountPerMonth;
    } catch (e) {
      print('Error fetching rental count for year: $e');
      return {}; // Return an empty map if error occurs
    }
  }

  Future<List> checkRental() async {
    List a = await rentalPropertyservice.getRentalByStatus(1) as List;
    print(a); // Debug the list here
    uploadUI();
    return a;
  }
}