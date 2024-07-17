import 'package:dio/dio.dart';
import 'package:insurance_map/data/local/temp_db.dart';
import 'package:insurance_map/data/remote/api_service/main_api_service.dart';
import 'package:insurance_map/data/remote/model/category.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/data/remote/model/slider_model.dart';
import 'package:insurance_map/utils/data_state.dart';

class MainRepository{
  final MainApiService _apiService;
  MainRepository(this._apiService);

  Future<DataState<List<SliderModel>>> getSliders() async {
    try {
      var response = await _apiService.getSliders();
      List<SliderModel> sliders = List.generate(response.data['data'].length, (index) => SliderModel.fromJson(response.data['data'][index]));
      return DataSucces(sliders);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<List<Category>>> getTopCategories() async {
    try {
      var response = await _apiService.getCategories(topCategories: true);
      List<Category> categories = List.generate(response.data['data'].length, (index) => Category.fromJson(response.data['data'][index]));
      return DataSucces(categories);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<List<Category>>> getCategories(String parentId, int page, int perPage) async {
    try {
      var response = await _apiService.getCategories(parentId: parentId, page: page, perPage: perPage);
      List<Category> categories = List.generate(response.data['data'].length, (index) => Category.fromJson(response.data['data'][index]));
      return DataSucces(categories);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<List<InsuranceCompany>>> getTopCompanies() async {
    try {
      var response = await _apiService.getCompanies(topCategories: true);
      List<InsuranceCompany> categories = List.generate(response.data['data'].length, (index) => InsuranceCompany.fromJson(response.data['data'][index]));
      return DataSucces(categories);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<List<InsuranceCompany>>> getCompanies() async {
    try {
      var response = await _apiService.getCompanies();
      List<InsuranceCompany> categories = List.generate(response.data['data'].length, (index) => InsuranceCompany.fromJson(response.data['data'][index]));
      return DataSucces(categories);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> getPageContent(String page) async {
    try {
      var response = await _apiService.getPageContent(page);
      TempDB.savePage(page, response.data['data']['content']);
      return DataSucces();
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> sendTicket(String title, String message, String priority) async {
    try {
      await _apiService.sendTicket(title, message, priority);
      return DataSucces();
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<void> getMessages() async {
    try {
      var response = await _apiService.getMessages('in-app-text');
      TempDB.saveMessages(response.data['data'].cast<Map<String, dynamic>>());
    } catch (_) {}
  }
}