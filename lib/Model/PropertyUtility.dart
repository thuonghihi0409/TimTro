import 'RentelProperty.dart';
import 'Utility.dart';

class PropertyUtility {
  final String propertyUtilityId;
  final RentalProperty rentalProperty;
  final Utility utility;

  PropertyUtility({
    required this.propertyUtilityId,
    required this.rentalProperty,
    required this.utility,
  });
  factory PropertyUtility.fromJson(Map<String, dynamic> json) {
    return PropertyUtility(
      propertyUtilityId: json['propertyUtilityId'],
      rentalProperty: RentalProperty.fromJson(json['rentalProperty']),
      utility: Utility.fromJson(json['utility']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyUtilityId': propertyUtilityId,
      'rentalPropertyId': rentalProperty.propertyId,
      'utilityId': utility.utilityId,
    };
  }
}