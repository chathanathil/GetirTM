import 'dart:convert';
import 'package:flutter/foundation.dart';
import './provider.dart';
import '../models/address.dart';
import '../models//discount_card.dart';

class UserProvider with ChangeNotifier {
  // remove static from fns and use provider in appropriate pages

  /// Update user info

  ///// ADDRESSES /////
  List<Address> _addresses = [];
  List<Address> get addresses {
    return _addresses;
  }

  /// Fetch all addresses of current user
  Future<void> fetchAddresses() async {
    var response = await RootProvider.http.get('/user/addresses');
    var extractData = json.decode(response.data);
    _addresses =
        (extractData as List).map((item) => Address.fromJson(item)).toList();
    notifyListeners();
  }

  /// Fetch given address
  static Future<Address> address(id) async {
    var response = await RootProvider.http.get("/user/addresses/$id");
    var extractData = json.decode(response.data);

    return Address.fromJson(extractData);
  }

  DiscountCardPoint _discountCard;
  DiscountCardPoint get discountCard {
    return _discountCard;
  }

  /// Verify discount card
  Future<String> verifyDiscountCard(int number) async {
    var response = await RootProvider.http
        .post('/user/card/verify', data: {"code": number});

    return response.data;
  }

  /// Get discount card
  Future<dynamic> getDiscountCard(Map data) async {
    var response = await RootProvider.http.post('/user/card/get', data: data);
    return response;
  }
}
