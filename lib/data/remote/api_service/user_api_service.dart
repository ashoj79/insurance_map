import 'package:dio/dio.dart';
import 'package:insurance_map/data/local/signup_step_one_data.dart';

class UserApiService {
  final Dio _dio;
  UserApiService(this._dio);

  Future<Response<dynamic>> sendOtp(String phone, String hash) async {
    FormData data = FormData.fromMap({'mobile': phone, 'hash': hash});
    return await _dio.post('auth/send-otp-to-mobile', data: data);
  }

  Future<Response<dynamic>> valiidateOtp(
      String phone, String otp, String type) async {
    FormData data = FormData.fromMap({'mobile': phone, 'otp_code': otp});
    String route = type == 'register' ? 'check-mobile-otp' : 'login';
    return await _dio.post('auth/$route', data: data);
  }

  Future<Response<dynamic>> registerStepOne(SignupStepOneData data) async {
    Map<String, dynamic> map = {
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
    };

    if (data.inviterCode.isNotEmpty) {
      map.addAll({'inviter_code': data.inviterCode});
    }

    FormData formData = FormData.fromMap(map);
    return await _dio.post('auth/register', data: formData);
  }

  Future<Response<dynamic>> getUserInfo() async => await _dio.get('auth/user');
}
