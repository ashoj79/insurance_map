import 'package:dio/dio.dart';

class UserApiService {
  final Dio _dio;
  UserApiService(this._dio);

  Future<Response<dynamic>> sendOtp(String phone) async {
    FormData data = FormData.fromMap({'mobile': phone});
    return await _dio.post('auth/send-otp-to-mobile', data: data);
  }

  Future<Response<dynamic>> valiidateOtp(String phone, String otp, String type) async {
    FormData data = FormData.fromMap({'mobile': phone, 'otp_code': otp});
    String route = type == 'register' ? 'check-mobile-otp' : 'login';
    return await _dio.post('auth/$route', data: data);
  }
}