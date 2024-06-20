import 'package:dio/dio.dart';

class ShopApiService {
  final Dio _dio;
  ShopApiService(this._dio);

  Future<Response<dynamic>> getAllVendors() async => await _dio.get('shop/vendors');

  Future<Response<dynamic>> getAllCategories() async => await _dio.get('shop/categories');
  
  Future<Response<dynamic>> saveVendor(int provinceId, int cityId, String categoryId, String shopName, String address, String postalCode, String lat, String lng) async {
    FormData data = FormData.fromMap({
      'province_id': provinceId,
      'city_id': cityId,
      'shop_category_id': categoryId,
      'shop_name': shopName,
      'address': address,
      'postal_code': postalCode,
      'latitude': lat,
      'longitude': lng
    });

    return await _dio.post('shop/vendors', data: data);
  }
}