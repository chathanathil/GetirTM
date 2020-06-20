import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getirtm/models/contact.dart';
import 'package:getirtm/models/feedback.dart';
import 'package:getirtm/provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/faq.dart';

class HomeProvider with ChangeNotifier {
  static final _storage = new FlutterSecureStorage();

  /// Fetch states
  static Future<List<Faq>> faqs() async {
    final response = await RootProvider.http.get('/faq');
    return (response.data['faq'] as List)
        .map((item) => Faq.fromJson(item))
        .toList();
  }

  static Future<String> about() async {
    String locale = await HomeProvider.getLocale();
    locale = locale == null ? 'ru' : locale;
    locale = locale == 'en' ? 'tm' : locale;
    final response = await RootProvider.http.get('/about?locale=$locale');
    print(response.data['url']);
    return response.data['url'];
  }

  static Future<String> terms() async {
    String locale = await HomeProvider.getLocale();
    locale = locale == null ? 'ru' : locale;
    locale = locale == 'en' ? 'tm' : locale;
    final response = await RootProvider.http.get('/terms?locale=$locale');
    print(response.data['url']);
    return response.data['url'];
  }

  static Future<String> privacy() async {
    String locale = await HomeProvider.getLocale();
    locale = locale == null ? 'ru' : locale;
    locale = locale == 'en' ? 'tm' : locale;
    final response = await RootProvider.http.get('/privacy?locale=$locale');
    print(response.data['url']);
    return response.data['url'];
  }

  static Future<Contact> contact() async {
    final response = await RootProvider.http.get('/contact');
    print(response);
    return Contact.fromJson(response.data['contact']);
  }

  static Future<List<FeedBackType>> fetchFeedbackTypes() async {
    final snapshot =
        await Firestore.instance.collection('feedback-types').getDocuments();
    return snapshot.documents
        .map((item) => FeedBackType.fromJson(item.data))
        .toList();
  }

  /// Check if has locale in storage
  static Future<bool> hasLocale() async {
    String locale = await _storage.read(key: 'locale');
    return locale != null;
  }

  /// Get locale from storage
  static Future<String> getLocale() async {
    return await _storage.read(key: 'locale');
  }

  /// Set locale
  static Future<void> setLocale([locale = 'ru']) async {
    await _storage.write(key: 'locale', value: locale);
  }
}
