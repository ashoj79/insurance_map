import 'package:dio/dio.dart';
import 'package:insurance_map/data/remote/api_service/bank_api_service.dart';
import 'package:insurance_map/data/remote/model/bank.dart';
import 'package:insurance_map/utils/data_state.dart';

class BankRepository {
  final BankApiService _apiService;
  BankRepository(this._apiService);

  Future<DataState<List<Bank>>> getBanks() async {
    try{
      var response = await _apiService.getBanks();
      List<Bank> data = List.generate(response.data['data'].length, (index) => Bank.fromJson(response.data['data'][index]));
      return DataSucces(data);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> addCard(String number) async {
    try{
      await _apiService.saveCard(number);
      return DataSucces();
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }
}