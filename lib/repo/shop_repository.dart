import 'package:dio/dio.dart';
import 'package:insurance_map/data/remote/api_service/shop_api_service.dart';
import 'package:insurance_map/data/remote/model/shop_category.dart';
import 'package:insurance_map/utils/data_state.dart';

class ShopRepository {
  final ShopApiService _apiService;
  ShopRepository(this._apiService);

  Future<DataState<List<ShopCategory>>> getAllCategories() async {
    try {
      var response = await _apiService.getAllCategories();
      List<ShopCategory> categories = List.generate(response.data['data'].length, (index) => ShopCategory.fromJson(response.data['data'][index]));
      return DataSucces(categories);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> saveVendor(int provinceId, int cityId, String categoryId, String shopName, String address, String postalCode, String lat, String lng) async {
    try {
      await _apiService.saveVendor(provinceId, cityId, categoryId, shopName, address, postalCode, lat, lng);
      return DataSucces();
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }
}