import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getirtm/helpers/shared_preferences_helper.dart';
import 'package:getirtm/models/http_exception.dart';
import 'package:getirtm/models/user.dart';
import 'package:getirtm/provider/provider.dart';

import '../models/address.dart';

final Firestore _db = Firestore.instance;

class AddressProvider with ChangeNotifier {
  List<dynamic> addresses = [];
  List<City> cities = [];
  List<AddressType> types = [];
  String addressMsg = "";

  Future<List<AddressType>> fetchAddressTypes() async {
    final snapshot = await _db.collection('addressTypes').getDocuments();
    return snapshot.documents
        .map((item) => AddressType.fromJson(item.data))
        .toList();
  }

  Future<List<City>> fetchCities() async {
    final snapshot = await _db.collection('cities').getDocuments();
    return snapshot.documents.map((item) => City.fromJson(item.data)).toList();
  }

  Future addAddress(Map body) async {
    try {
      var response = await RootProvider.http.post('/addresses', data: body);
      addresses.insert(0, Address.fromJson(response.data['address']));
      addressMsg =
          response.data["message"] != null ? response.data["message"] : "";
      notifyListeners();
    } on DioError catch (error) {
      throw HttpException(error.response.data['message']);
    }
  }

  Future updateAddress(Map body) async {
    final prodIndex = addresses.indexWhere((prod) => prod.id == body['id']);
    try {
      var response =
          await RootProvider.http.put('/addresses/${body['id']}', data: body);
      addresses[prodIndex] = Address.fromJson(response.data['address']);
      addressMsg =
          response.data["message"] != null ? response.data["message"] : "";

      notifyListeners();
    } on DioError catch (error) {
      throw HttpException(error.response.data['message']);
    }
  }

  Future fetchAddresses() async {
    User user = await SharedPreferencesHelper.getUserDetails();
    final snapshot = await _db
        .collection('users')
        .document(user.id.toString())
        .collection('addresses')
        .getDocuments();
    snapshot.documents
        .map((item) => addresses.add(Address.fromJson(item.data)))
        .toList();
    notifyListeners();
  }

  Future deleteAddress(int id) async {
    final existingAddressIndex = addresses.indexWhere((prod) => prod.id == id);
    var existingAddress = addresses[existingAddressIndex];
    addresses.removeAt(existingAddressIndex);
    notifyListeners();
    try {
      var response = await RootProvider.http.delete("/addresses/$id");
      return response.data['message'];
    } on DioError catch (error) {
      addresses.insert(existingAddressIndex, existingAddress);
      notifyListeners();
      existingAddress = null;
      throw HttpException(error.response.data['message']);
    }
  }
}
