import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getirtm/helpers/shared_preferences_helper.dart';
import 'package:getirtm/models/appContent.dart';
import '../models/http_exception.dart';
import '../models/user.dart';

import './provider.dart';

class AuthProvider with ChangeNotifier {
  static final _storage = new FlutterSecureStorage();
  final Firestore _db = Firestore.instance;

  bool _authenticated = false;
  User _user;
  static AppContent appContent;
  bool get isAuthenticated {
    return _authenticated;
  }

  User get user {
    return _user;
  }

  // AppContent get appContent {
  //   return _appContent;
  // }

  Future appContents() async {
    final snapshot =
        await _db.collection('app-content-text').document('contents').get();
    print(AppContent.fromJson(snapshot.data));
    appContent = AppContent.fromJson(snapshot.data);
  }

  /// Send verification code
  Future<void> login({@required String phone, @required String name}) async {
    try {
      await RootProvider.http
          .post('/auth/login', data: {'name': 'Maksat', 'phone': '64871221'});
      print('auth');
    } on DioError catch (error) {
      print(error.response.data['message']);
      throw HttpException(error.response.data['message']);
    }
  }

  /// Verify user
  Future<void> verify({
    @required String phone,
    @required String otp,
  }) async {
    try {
      var response = await RootProvider.http.post('/auth/verify', data: {
        'phone': 64871221,
        'otp': 123456,
      });
      print('auth');
      print(response);
      await persistToken(response.data['access_token']);
      await SharedPreferencesHelper.setUserDetails(response.data['user']);
      await hasToken();
      // _authenticated = true;
      // _user = User.fromJson(response.data["user"]);

      notifyListeners();
      // return response.data['access_token'];
    } on DioError catch (error) {
      print(error.response.data['message']);
      throw HttpException(error.response.data['message']);
    }
  }

  /// Securely save token
  static Future<void> persistToken(String token) async {
    await _storage.write(key: 'token', value: token);
    print('token stored');
  }

  // /// Check if has token
  Future hasToken() async {
    print('chechT');
    String token = await _storage.read(key: 'token');

    _authenticated = token != null;
    _user = await SharedPreferencesHelper.getUserDetails();
    print(_user);
    notifyListeners();
    // return token != null;
  }

  Future updateUser(Map data) async {
    var response = await RootProvider.http.post('/users/update', data: data);
    print(response);
    print("use me");
    _user.name = data['name'];
    await SharedPreferencesHelper.setUserDetails(response.data['user']);
    // notifyListeners();
    // return response.data;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    // await RootProvider.setRequestHeaders();
    _authenticated = false;
    print('logout');
    print(_authenticated);
    String token = await _storage.read(key: 'token');
    print(token);
    notifyListeners();
  }

  /// Delete token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
    // notifyListeners();
  }

  /// Get token
  static Future<String> getToken() async {
    return await _storage.read(key: 'token');
  }
}
