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
          return; // Nếu gặp lỗi thì dừng lại
        }
      }

      // Sau khi hoàn thành, cập nhật giao diện
      uploadUI();

    } catch (e) {
      print("Lỗi xảy ra: $e");
    }
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
}