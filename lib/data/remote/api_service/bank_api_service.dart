import 'package:dio/dio.dart';

class BankApiService {
  final Dio _dio;
  BankApiService(this._dio);

  Future<Response<dynamic>> getBanks() async => await _dio.get('banks');

  Future<Response<dynamic>> getPaymentUrl() async => await _dio.get('users/bank-cards/activate');

  Future<Response<dynamic>> getUserCards() async => await _dio.get('users/bank-cards');

  Future<Response<dynamic>> saveCard(String number) async {
    FormData data = FormData.fromMap({'number': number});
    return await _dio.post('users/bank-cards', data: data);
  }
}