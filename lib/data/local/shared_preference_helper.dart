import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SharedPreferenceHelper {
  final StreamingSharedPreferences _sharedPreferences;
  SharedPreferenceHelper(this._sharedPreferences);

  clean() async => await _sharedPreferences.clear();

  Future<void> saveToken(String data) async => await _sharedPreferences.setString('token', data);
  String getToken() => _sharedPreferences.getString('token', defaultValue: '').getValue();

  Future<void> saveName(String data) async => await _sharedPreferences.setString('name', data);
  getName() => _sharedPreferences.getString('name', defaultValue: '');

  Future<void> savePhone(String data) async => await _sharedPreferences.setString('phone', data);
  getPhone() => _sharedPreferences.getString('phone', defaultValue: '');

  Future<void> saveAvatar(String data) async => await _sharedPreferences.setString('avatar', data);
  getAvatar() => _sharedPreferences.getString('avatar', defaultValue: '');

  Future<void> saveWallet(int data) async => await _sharedPreferences.setInt('wallet', data);
  getWallet() => _sharedPreferences.getInt('wallet', defaultValue: 0);

  Future<void> saveInviteCode(String data) async => await _sharedPreferences.setString('invite_code', data);
  getInviteCode() => _sharedPreferences.getString('invite_code', defaultValue: '').getValue();
}