import 'dart:io';

import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/data/remote/api_service/user_api_service.dart';
import 'package:insurance_map/utils/data_state.dart';

class UserRepository {
  final UserApiService _apiService;
  final SharedPrefereceHelper _sharedPrefereceHelper;
  UserRepository(this._apiService, this._sharedPrefereceHelper);

  Future<DataState<String>> sendOtp(String phone) async {
    try {
      var response = await _apiService.sendOtp(phone);
      return DataSucces(response.data['type']);
    } on HttpException catch (e) {
      return DataError(e.message);
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> validateOtp(String phone, String otp, String type) async {
    try {
      var response = await _apiService.valiidateOtp(phone, otp, type);
      if (!response.data['isOtpCodeValid']) {
        return DataError('کد وارد شده معتبر نمی باشد');
      }

      if (type == 'login') {
        await _sharedPrefereceHelper.saveToken(response.data['token']);
      }

      return DataSucces();
    } on HttpException catch (e) {
      return DataError(e.message);
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }
}