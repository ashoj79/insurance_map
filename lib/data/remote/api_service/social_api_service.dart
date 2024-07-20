import 'package:dio/dio.dart';

class SocialApiService {
  final Dio _dio;
  SocialApiService(this._dio);

  Future<Response<dynamic>> getResponsibilities(String cityId, String provinceId) async {
    String filter = '';
    if (cityId.isNotEmpty) {
      filter = '?filters[city][id][\$eq]=$cityId';
    } else if (provinceId.isNotEmpty) {
      filter = '?filters[province][id][\$eq]=$provinceId';
    }

    return await _dio.get('social-responsibilities$filter');
  }
}