import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getirtm/helpers/shared_preferences_helper.dart';
import 'package:getirtm/models/appContent.dart';
import '../models/http_exception.dart';
import '../models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  Future appContents() async {
    final snapshot =
        await _db.collection('app-content-text').document('contents').get();
    appContent = AppContent.fromJson(snapshot.data);
  }

  static final FirebaseMessaging _fcm = FirebaseMessaging();

  static Future<String> storeFcmToken() async {
    String token = await _storage.read(key: 'fcm_token');
    if (token == null) {
      String fcmToken = await _fcm.getToken();
      if (fcmToken != null) {
        await _storage.write(key: 'fcm_token', value: fcmToken);
        return fcmToken;
      }
    }
    return token;
  }

  /// Send verification code
  Future<void> login({@required String phone, @required String name}) async {
    try {
      final fcmToken = await storeFcmToken();
      final response = await RootProvider.http.post('/auth/login', data: {
        'fcm_token': fcmToken,
        'name': name,
        'phone': phone,
      });
    } on DioError catch (error) {
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
        'phone': phone,
        'otp': otp,
      });
      await persistToken(response.data['access_token']);
      await SharedPreferencesHelper.setUserDetails(response.data['user']);
      await hasToken();
      await RootProvider.init();
      notifyListeners();
    } on DioError catch (error) {
      throw HttpException(error.response.data['message']);
    }
  }

  /// Securely save token
  static Future<void> persistToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // /// Check if has token
  Future hasToken() async {
    String token = await _storage.read(key: 'token');
    _authenticated = token != null;
    _user = await SharedPreferencesHelper.getUserDetails();
    notifyListeners();
  }

  Future updateUser(Map data) async {
    var response = await RootProvider.http.post('/users/update', data: data);
    _user.name = data['name'];
    await SharedPreferencesHelper.setUserDetails(response.data['user']);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _authenticated = false;
    String token = await _storage.read(key: 'token');
    notifyListeners();
  }

  /// Delete token
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  /// Get token
  static Future<String> getToken() async {
    String token = await _storage.read(key: 'token');

    return token;
  }
}
