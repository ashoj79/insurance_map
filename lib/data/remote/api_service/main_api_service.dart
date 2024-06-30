import 'package:dio/dio.dart';

class MainApiService{
  final Dio _dio;
  MainApiService(this._dio);

  Future<Response<dynamic>> getSliders() async => await _dio.get('sliders');

  Future<Response<dynamic>> getCategories({bool topCategories = false, String parentId = '', int page = 0, int perPage = 0}) async {
    Map<String, dynamic> params = {
      'top_categories': topCategories ? 1 : 0
    };
    return await _dio.get('shop/categories', queryParameters: params);
  }
}