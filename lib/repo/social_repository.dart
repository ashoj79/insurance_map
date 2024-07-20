import 'package:dio/dio.dart';
import 'package:insurance_map/data/remote/api_service/social_api_service.dart';

import '../utils/data_state.dart';

class SocialRepository {
  final SocialApiService _apiService;
  SocialRepository(this._apiService);

  Future<DataState<List<String>>> getResponsibilities({String cityId = '', String provinceId = ''}) async {
    try {
      var response = await _apiService.getResponsibilities(cityId, provinceId);
      List<String> categories = List.generate(response.data['data'].length, (index) => response.data['data'][index]['title']);
      return DataSucces(categories);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }
}