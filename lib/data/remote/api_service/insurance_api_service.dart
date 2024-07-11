import 'package:dio/dio.dart';

class InsuranceApiService {
  final Dio _dio;
  InsuranceApiService(this._dio);
  
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

  Future<Response<dynamic>> getCompanies() async => await _dio.get('insurance/companies');

  Future<Response<dynamic>> getOffices({required String company, String fromLat = '', String fromLng = '', String toLat = '', String toLng = ''}) async {
    String params = 'filters[insuranceCompany][id][\$eq]=$company&filters[latitude][\$between][0]=$fromLat&filters[longitude][\$between][0]=$fromLng&filters[latitude][\$between][1]=$toLat&filters[longitude][\$between][1]=$toLng';
    return await _dio.get('insurance/offices?$params');
  }
}