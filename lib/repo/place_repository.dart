import 'package:dio/dio.dart';
import 'package:insurance_map/data/remote/api_service/place_api_service.dart';
import 'package:insurance_map/data/remote/model/province_city.dart';
import 'package:insurance_map/utils/data_state.dart';

class PlaceRepository {
  final PlaceApiService _apiService;
  PlaceRepository(this._apiService);

  Future<DataState<List<ProvinceAndCity>>> getAllProvinces() async {
    try {
      var response = await _apiService.getAllProvinces();
      List<ProvinceAndCity> data = List.generate(response.data['data'].length, (index) => ProvinceAndCity.fromJson(response.data['data'][index]));
      return DataSucces(data);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<List<ProvinceAndCity>>> getCities(int provinceId) async {
    try {
      var response = await _apiService.getCities(provinceId);
      List<ProvinceAndCity> data = List.generate(response.data['data'].length, (index) => ProvinceAndCity.fromJson(response.data['data'][index]));
      return DataSucces(data);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }
}