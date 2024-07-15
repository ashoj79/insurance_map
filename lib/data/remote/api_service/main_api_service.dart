import 'package:dio/dio.dart';

class MainApiService{
  final Dio _dio;
  MainApiService(this._dio);

  Future<Response<dynamic>> getSliders() async => await _dio.get('sliders');

  Future<Response<dynamic>> getCategories({bool topCategories = false, String parentId = '', int page = 0, int perPage = 0}) async {
    Map<String, dynamic> params = {};
    if (!topCategories) {
      params.addAll({'page': page, 'per_page': perPage});
    } else {
      params.addAll({'top_categories': 1});
    }
    if (parentId.isNotEmpty) {
      params.addAll({'parent_id': parentId});
    }
    return await _dio.get('shop/categories', queryParameters: params);
  }

  Future<Response<dynamic>> getCompanies({bool topCategories = false}) async {
    Map<String, dynamic> params = {};
    if (topCategories) {
      params.addAll({'top_categories': 1});
    }

    return await _dio.get('insurance/companies', queryParameters: params);
  }

  Future<Response<dynamic>> getPageContent(String page) async => await _dio.get('pages/$page');
}