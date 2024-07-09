import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/utils/constanse.dart';

class DioHelper {
  Dio? _dio;
  Dio get dio => _dio!;
  SharedPreferenceHelper sharedPrefereceHelper;

  DioHelper(this.sharedPrefereceHelper) {
    _setupDio();
  }

  _setupDio() {
    var options = BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60));
    _dio = Dio(options)..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        String token = sharedPrefereceHelper.getToken();
        options.headers.addAll({'Accept': 'application/json', 'Authorization': 'Bearer $token'});
        return handler.next(options);
      },

      onError: (error, handler) {
        if (error.response == null){
          return handler.next(DioException(requestOptions: RequestOptions(), response: Response(requestOptions: RequestOptions(), data: 'مشکلی پیش آمد مجددا امتحان کنید')));
        }
        dynamic res = error.response?.data ?? '';
        Map<String, dynamic> data = res is String ? jsonDecode(res) : res;
        return handler.next(DioException(requestOptions: RequestOptions(), response: Response(requestOptions: RequestOptions(), data: data['message'])));
      },
    ));
  }
}
