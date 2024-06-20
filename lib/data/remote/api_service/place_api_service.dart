import 'package:dio/dio.dart';

class PlaceApiService {
  final Dio _dio;
  PlaceApiService(this._dio);

  Future<Response<dynamic>> getAllProvinces() async => await _dio.get('provinces');

  Future<Response<dynamic>> getCities(int provinceId) async => await _dio.get('provinces/$provinceId/cities');
}