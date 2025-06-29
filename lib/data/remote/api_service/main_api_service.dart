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
    return await _dio.get('shops/categories', queryParameters: params);
  }

  Future<Response<dynamic>> getCompanies({bool topCategories = false}) async {
    Map<String, dynamic> params = {};
    if (topCategories) {
      params.addAll({'top_categories': 1});
    }

    return await _dio.get('insurances/companies', queryParameters: params);
  }

  Future<Response<dynamic>> getPageContent(String page) async => await _dio.get('pages/$page');

  Future<Response<dynamic>> getMessages(String type) async => await _dio.get('notification-messages?filters[type]=$type');

  Future<Response<dynamic>> sendTicket(String title, String message, String priority) async {
    FormData data = FormData.fromMap({'title': title, 'message': message, 'priority': priority});
    return await _dio.post('tickets', data: data);
  }
}