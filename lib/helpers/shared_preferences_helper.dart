import 'package:getirtm/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String _userId = 'userId';
  static final String _userName = 'userName';
  static final String _phone = 'phone';

  static setUserDetails(Map user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt(_userId, user['id']);
    prefs.setString(_userName, user['name']);
    prefs.setInt(_phone, user['phone']);
  }

  static getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return User(
      id: prefs.getInt(_userId),
      name: prefs.getString(_userName),
      phone: prefs.getInt(_phone),
    );
  }
}
