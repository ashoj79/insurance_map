import 'package:dio/dio.dart';

class VehiclesApiService{
  final Dio _dio;
  VehiclesApiService(this._dio);

  Future<Response<dynamic>> getUserVehicles() async => await _dio.get('users/vehicles');

  Future<Response<dynamic>> getCarTypes() async => await _dio.get('cars/types');

  Future<Response<dynamic>> getCarBrands(int type) async => await _dio.get('cars/types/$type/brands');
  
  Future<Response<dynamic>> getCarModels(int type, int brand) async => await _dio.get('cars/types/$type/brands/$brand/models');

  Future<Response<dynamic>> saveVehicle(String type, String license, int carTypeId, int carBrandId, int carModelId, bool thirdPartyInsurance, String thirdPartyInsuranceDate, bool carBodyInsurance, String carBodyInsuranceDate) async {
    Map<String, dynamic> map = {
      'type': type,
      'license_plate': license,
      'has_third_party_insurance': thirdPartyInsurance ? 1 : 0,
      'has_car_body_insurance': carBodyInsurance ? 1 : 0,
    };

    if (type == 'car') {
      map.addAll({
        'car_type_id': carTypeId,
        'car_brand_id': carBrandId,
        'car_model_id': carModelId,
      });
    }

    if (thirdPartyInsurance) {
      map.addAll({'third_party_insurance_due_date': thirdPartyInsuranceDate});
    }

    if (carBodyInsurance) {
      map.addAll({'car_body_insurance_due_date': carBodyInsuranceDate});
    }

    FormData data = FormData.fromMap(map);

    return await _dio.post('users/vehicles', data: data);
  }

  Future<Response<dynamic>> saveRequest(String id, String description, String companyId, String type, String date) async {
    FormData data = FormData.fromMap({'user_vehicle_id': id, 'description': description, 'insurance_company_id': companyId, 'insurance_type': type, 'insurance_due_date': date});
    return await _dio.post('insurances/vehicles/requests', data: data);
  }
}