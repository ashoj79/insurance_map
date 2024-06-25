import 'package:dio/dio.dart';

class VehiclesApiService{
  final Dio _dio;
  VehiclesApiService(this._dio);

  Future<Response<dynamic>> getCarTypes() async => await _dio.get('cars/types');

  Future<Response<dynamic>> getCarBrands(int type) async => await _dio.get('cars/types/$type/brands');
  
  Future<Response<dynamic>> getCarModels(int type, int brand) async => await _dio.get('cars/types/$type/brands/$brand/models');

  Future<Response<dynamic>> saveVehicle(String type, String license, int carTypeId, int carBrandId, int carModelId, bool thirdPartyInsurance, String thirdPartyInsuranceDate, bool carBodyInsurance, String carBodyInsuranceDate) async {
    FormData data = FormData.fromMap({
      'type': type,
      'license_plate': license,
      'car_type_id': carTypeId,
      'car_brand_id': carBrandId,
      'car_model_id': carModelId,
      'has_third_party_insurance': thirdPartyInsurance ? 1 : 0,
      'third_party_insurance_due_date': thirdPartyInsuranceDate,
      'has_car_body_insurance': carBodyInsurance ? 1 : 0,
      'car_body_insurance_due_date': carBodyInsuranceDate,
    });

    return await _dio.post('users/vehicles', data: data);
  }
}