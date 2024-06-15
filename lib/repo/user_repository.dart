import 'dart:io';

import 'package:dio/dio.dart';
import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/data/local/signup_step_one_data.dart';
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
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> validateOtp(String phone, String otp, String type) async {
    try {
      var response = await _apiService.valiidateOtp(phone, otp, type);

      if (type == 'login') {
        await _sharedPrefereceHelper.saveToken(response.data['token']);
      }

      return DataSucces();
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
      return DataSucces();
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }
}