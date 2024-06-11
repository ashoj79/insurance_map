import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefereceHelper {
  final SharedPreferences _sharedPreferences;
  SharedPrefereceHelper(this._sharedPreferences);

  saveToken(String token) async => await _sharedPreferences.setString('token', token);
  getToken() => _sharedPreferences.getString('token') ?? '';
}