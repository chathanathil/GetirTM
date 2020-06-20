import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import './provider.dart';
import '../models/user.dart';
import '../models/address.dart';
import '../models//discount_card.dart';
import '../helpers/shared_preferences_helper.dart';

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

  /// Add new address
  static Future<Address> addAddress(Map body) async {
    // var response = await http.post('/user/addresses', body: body);
    // var extractData = json.decode(response.body);

    // return Address.fromJson(extractData);
  }

  /// Update address
  static Future<Address> updateAddress(Map body) async {
    // var response = await http.post(
    //   "/user/addresses/${body['id']}",
    //   body: body,
    // );
    // var extractData = json.decode(response.body);

    // return Address.fromJson(extractData);
  }

  /// Make given address default
  static Future<String> defaultAddress(int id) async {
    // var response = await http.post("/user/addresses/$id/default");
    // var extractData = json.decode(response.body);

    // return extractData;
  }

  /// Delete address
  static Future<String> deleteAddress(int id) async {
    // var response = await http.delete("/user/addresses/$id");
    // var extractData = json.decode(response.body);

    // return extractData;
  }
  DiscountCardPoint _discountCard;
  DiscountCardPoint get discountCard {
    return _discountCard;
  }

  /// Fetch discount card and points
  Future<DiscountCardPoint> fetchAllDiscountCards() async {
    print('call api');
    // var response = await RootProvider.http.get('/user/card');
    // var dCard = DiscountCardPoint.fromJson(response.data);
    // SharedPreferencesHelper.setUserBalanceAndPercentage(
    //     dCard.discountCard.balance, dCard.discountCard.percentage);

    // return dCard;
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
