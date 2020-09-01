// import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getirtm/models/contact.dart';
import 'package:getirtm/models/feedback.dart';
import 'package:getirtm/provider/provider.dart';

import '../models/faq.dart';

class HomeProvider with ChangeNotifier {
  static final _storage = new FlutterSecureStorage();
  String locale = RootProvider.locale;

  /// Fetch states
  static Future<List<Faq>> faqs() async {
    final response = await RootProvider.http.get('/faq');
    return (response.data['faq'] as List)
        .map((item) => Faq.fromJson(item))
        .toList();
  }

  static Future<String> about() async {
    String locale = await _storage.read(key: 'locale');
    locale = locale == null ? 'ru' : locale;
    locale = locale == 'en' ? 'tm' : locale;
    final response = await RootProvider.http.get('/about?locale=$locale');
    return response.data['url'];
  }

  static Future<String> terms() async {
    String locale = await _storage.read(key: 'locale');
    locale = locale == null ? 'ru' : locale;
    locale = locale == 'en' ? 'tm' : locale;
    final response = await RootProvider.http.get('/terms?locale=$locale');
    return response.data['url'];
  }

  static Future<String> privacy() async {
    String locale = await _storage.read(key: 'locale');
    locale = locale == null ? 'ru' : locale;
    locale = locale == 'en' ? 'tm' : locale;
    final response = await RootProvider.http.get('/privacy?locale=$locale');
    return response.data['url'];
  }

  static Future<Contact> contact() async {
    final response = await RootProvider.http.get('/contact');
    return Contact.fromJson(response.data['contact']);
  }

  static Future<List<FeedBackType>> fetchFeedbackTypes() async {
    final snapshot =
        await Firestore.instance.collection('feedback-types').getDocuments();
    return snapshot.documents
        .map((item) => FeedBackType.fromJson(item.data))
        .toList();
  }

  static Future addFeedback(
      String title, String text, int type, List<File> image) async {
    List img = [];
    image.forEach((element) async {
      String fileName = element.path.split('/').last;
      var m = await MultipartFile.fromFile(element.path, filename: fileName);
      img.add(m);
    });

    var formData = FormData.fromMap(
        {'type_id': type, 'title': title, 'text': text, "images": img});

    final response = await RootProvider.http.post('/feedback', data: formData);
    print('ffeedres');
    print(response);
    return response.data['message'];
  }

  /// Check if has locale in storage
  static Future<bool> hasLocale() async {
    String locale = await _storage.read(key: 'locale');
    return locale != null;
  }

  /// Get locale from storage
  static Future<String> getLocale() async {
    String lc = await _storage.read(key: 'locale');
    // locale = lc == 'en' ? 'tm' : lc;
    // notifyListeners();
    return lc;
  }

  static Future<void> setLocales([lc = 'ru']) async {
    await _storage.write(key: 'locale', value: lc);
  }

  /// Set locale
  Future<void> setLocale([lc = 'ru']) async {
    print("homile sel loc");
    print(lc);
    await _storage.write(key: 'locale', value: lc);
    locale = lc == 'en' ? 'tm' : lc;
    print(locale);
    notifyListeners();
  }
}
