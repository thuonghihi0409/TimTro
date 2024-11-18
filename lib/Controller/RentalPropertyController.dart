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
   Future <void> postRental (RentalProperty rental, List<Utility> list) async {
    await rentalPropertyservice.postRentalProperty(rental);
     for(Utility utility in list){
      await rentalPropertyservice.postUtilityOfRentalProperty(PropertyUtility(propertyUtilityId: "xx", rentalProperty: rental, utility: utility));
     }
     uploadUI();
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