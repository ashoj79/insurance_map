import 'package:dio/dio.dart';
import 'package:insurance_map/data/local/signup_step_one_data.dart';

class UserApiService {
  final Dio _dio;
  UserApiService(this._dio);

  Future<Response<dynamic>> sendOtp(String phone) async {
    FormData data = FormData.fromMap({'mobile': phone});
    return await _dio.post('auth/send-otp-to-mobile', data: data);
  }

  Future<Response<dynamic>> valiidateOtp(
      String phone, String otp, String type) async {
    FormData data = FormData.fromMap({'mobile': phone, 'otp_code': otp});
    String route = type == 'register' ? 'check-mobile-otp' : 'login';
    return await _dio.post('auth/$route', data: data);
  }

  Future<Response<dynamic>> registerStepOne(SignupStepOneData data) async {
    FormData formData = FormData.fromMap({
      'mobile': data.phone,
      'otp_code': data.otp,
      'first_name': data.fname,
      'last_name': data.lname,
      'father_name': data.fatherName,
      'national_code': data.nc,
      'birth_certificate_id': data.certId,
      'sex': data.sex,
      'birth_date': data.birthDate,
      'place_of_birth': data.place,
      'job_title': data.job,
      'inviter_code': data.inviterCode
    });
    return await _dio.post('auth/register', data: formData);
  }

  Future<Response<dynamic>> getUserInfo() async => await _dio.get('auth/user');
}
