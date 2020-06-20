import 'package:getirtm/provider/provider.dart';

class AppContent {
  final Map<String, dynamic> myProfile;
  final Map<String, dynamic> myAddresses;
  final Map<String, dynamic> discountCart;
  final Map<String, dynamic> home;

  AppContent({this.myProfile, this.discountCart, this.home, this.myAddresses});

  factory AppContent.fromJson(Map<String, dynamic> json) {
    return AppContent(
      myProfile: json['myProfile'] as Map<String, dynamic>,
      myAddresses: json['myAddresses'] as Map<String, dynamic>,
      discountCart: json['discountCart'] as Map<String, dynamic>,
      home: json['home'] as Map<String, dynamic>,
    );
  }
}
