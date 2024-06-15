import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:insurance_map/utils/constanse.dart';

class DioHelper {
  Dio? _dio;
  Dio get dio => _dio!;

  DioHelper() {
    _setupDio();
  }

  _setupDio() {
    var options = BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60));
    _dio = Dio(options)..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers.addAll({'Accept': 'application/json'});
        return handler.next(options);
      },

      onResponse: (response, handler) {
        if ((response.statusCode ?? 200) != 403 && (response.statusCode ?? 200) != 422) {
          return handler.next(response);
        }

        Map<String, dynamic> data = response.data is String ? jsonDecode(response.data) : response.data;
        return handler.next(Response(requestOptions: RequestOptions(), data: data['message'], statusCode: 400));
      },
    ));
  }
}
