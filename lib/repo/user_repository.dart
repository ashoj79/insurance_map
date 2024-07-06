import 'package:dio/dio.dart';
import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/data/local/signup_step_one_data.dart';
import 'package:insurance_map/data/remote/api_service/user_api_service.dart';
import 'package:insurance_map/data/remote/model/user_info.dart';
import 'package:insurance_map/utils/data_state.dart';

class UserRepository {
  final UserApiService _apiService;
  final SharedPreferenceHelper _sharedPrefereceHelper;
  UserRepository(this._apiService, this._sharedPrefereceHelper);

  Future<DataState<String>> sendOtp(String phone) async {
    try {
      var response = await _apiService.sendOtp(phone);
      return DataSucces(response.data['type']);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<UserInfo>> validateOtp(String phone, String otp, String type) async {
    try {
      var response = await _apiService.valiidateOtp(phone, otp, type);

      if (type == 'login') {
        await _sharedPrefereceHelper.saveToken(response.data['token']);
        await _sharedPrefereceHelper.saveName(response.data['user']['name']);
        await _sharedPrefereceHelper.savePhone(response.data['user']['mobile']);
        await _sharedPrefereceHelper.saveAvatar(response.data['user']['avatar']);
        await _sharedPrefereceHelper.saveWallet(int.tryParse(response.data['user']['wallet']['balance']) ?? 0);
        response = await _apiService.getUserInfo();
      }

      return DataSucces(UserInfo.fromJson(response.data));
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> signupStepOne(SignupStepOneData data) async {
    try {
      var response = await _apiService.registerStepOne(data);
      await _sharedPrefereceHelper.saveToken(response.data['token']);
      await _sharedPrefereceHelper.saveName('${data.fname} ${data.lname}');
      await _sharedPrefereceHelper.savePhone(data.phone);
      await _sharedPrefereceHelper.saveAvatar('');
      await _sharedPrefereceHelper.saveWallet(0);
      return DataSucces();
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<void> updateWalletBalance() async {
    try {
      if (_sharedPrefereceHelper.getToken().isNotEmpty) {
        var response = await _apiService.getUserInfo();
        await _sharedPrefereceHelper.saveWallet(
            int.tryParse(response.data['user']['wallet']['balance']) ?? 0);
      }
    } catch (_) {}
  }
}