import 'package:dio/dio.dart';

class ShopApiService {
  final Dio _dio;
  ShopApiService(this._dio);

  Future<Response<dynamic>> getAllVendors() async => await _dio.get('shops/vendors');

  Future<Response<dynamic>> getAllCategories() async => await _dio.get('shops/categories');
  
  Future<Response<dynamic>> saveVendor(int provinceId, int cityId, String categoryId, String shopName, String address, String postalCode, String lat, String lng, String phone) async {
    FormData data = FormData.fromMap({
      'province_id': provinceId,
      'city_id': cityId,
      'shop_category_id': categoryId,
      'shop_name': shopName,
      'address': address,
      'postal_code': postalCode,
      'latitude': lat,
      'longitude': lng,
      'phone_number': phone,
    });

    return await _dio.post('shops/vendors', data: data);
  }

  Future<Response<dynamic>> getVendors({required String category, String fromLat = '', String fromLng = '', String toLat = '', String toLng = ''}) async {
    String params = category.isNotEmpty ? 'filters[category][id][\$eq]=$category&' : '';
    params += 'filters[latitude][\$between][0]=$fromLat&filters[longitude][\$between][0]=$fromLng&filters[latitude][\$between][1]=$toLat&filters[longitude][\$between][1]=$toLng';
    return await _dio.get('shops/vendors?$params');
  }

  Future<Response<dynamic>> createCashRequest(int amount, String vendorId) async {
    var data = FormData.fromMap({'amount': amount, 'vendor_id': vendorId});
    return await _dio.post('shops/cash-back-requests', data: data);
  }
}