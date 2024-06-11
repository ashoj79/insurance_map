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
    _dio = Dio(options);
  }
}
