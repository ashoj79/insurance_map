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
    });
    return await _dio.post('auth/register', data: formData);
  }

  Future<Response<dynamic>> saveInsuranceOffice(int provinceId, int cityId, String insuranceCompanyId, String officeName, String officeCode, String address, String postalCode, String lat, String lng) async {
    FormData data = FormData.fromMap({
      'province_id': provinceId,
      'city_id': cityId,
      'insurance_company_id': insuranceCompanyId,
      'office_name': officeName,
      'office_code': officeCode,
      'address': address,
      'postal_code': postalCode,
      'latitude': lat,
      'longitude': lng
    });

    return await _dio.post('insurance/offices', data: data);
  }

  Future<Response<dynamic>> getAllProvinces() async => await _dio.get('provinces');

  Future<Response<dynamic>> getCities(int provinceId) async => await _dio.get('provinces/$provinceId/cities');

  Future<Response<dynamic>> getCompanies() async => await _dio.get('insurance/companies');
}
