import 'package:package_info/package_info.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import './home.dart';
import './auth.dart';

// String token;

class RootProvider {
  static Dio http = Dio();
  static final baseUrl = "http://getir.safedevs.com/api";
  static String locale = '';

  static Future<void> setRequestHeaders() async {
    String token = await AuthProvider.getToken();
    String _locale = await HomeProvider.getLocale();
    locale = _locale == 'en' ? 'tm' : _locale;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String platform = "";

    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    }

    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Language': _locale == 'en' ? 'tm' : _locale,
      'Version': packageInfo?.version,
      'Platform': platform,
    };
    if (token != null) headers['Authorization'] = "Bearer $token";
    http.options.baseUrl = baseUrl;
    http.options.headers = headers;
  }

  static init() async {
    await setRequestHeaders();

    http.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          print('Making request to ${options.method} ${options.uri}');
        },
        onResponse: (Response response) {
          // if response successful then return data

          if (response.data['success'] == true && response.data['success']) {
            return http.resolve(response);
          }

          return http.reject(response.data['message']);
        },
        onError: (DioError e) async {
          if (e.response != null && e.response.statusCode == 401) {
            await AuthProvider.deleteToken();
          }

          return http.reject(e);
        },
      ),
    );
  }
}
