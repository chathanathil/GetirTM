import 'package:getirtm/provider/cart.dart';
import 'package:package_info/package_info.dart';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';

import './home.dart';
import './auth.dart';

class Result {
  final success;
  final message;
  const Result(this.success, this.message);
}

String token;

class RootProvider {
  static Dio http = Dio();
  static final baseUrl = "http://getir.safedevs.com/api";
  static String locale = '';
  static Future<void> setRequestHeaders() async {
    token = await AuthProvider.getToken();
    String _locale = await HomeProvider.getLocale();
    print(_locale);
    locale = _locale == 'en' ? 'tm' : _locale;
    print(locale);
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
        onRequest: (RequestOptions options) {
          print('Making request to ${options.method} ${options.uri}');
        },
        onResponse: (Response response) {
          // if response successful then return data
          print('root');
          // print(token);
          // print(response);
          // print(response.data);
          // Check here £££££££££££333@
          if (response.data['success'] == true && response.data['success']) {
            // print('root');
            // print(response.data['data']);
            // print(response);
            return http.resolve(response);
          }
          // if (response.data['status'] == false && response.data['status']) {
          //   print('root');
          //   print(response.data['data']);
          //   print(response);
          //   return http.resolve(response.data);
          // }

          return http.reject(response.data['message']);
        },
        onError: (DioError e) async {
          print(e.response);
          print("error");
          print(e.response.data);

          print(token);

          print(e);
          // 401 unathorized, remove token if fails
          // print(e.message);
          if (e.response != null && e.response.statusCode == 401) {
            await AuthProvider.deleteToken();
            // delete tokken so uncoomment the above line
          }

          return http.reject(e);
          // return DioError(message: e.message);
        },
      ),
    );
  }
}
