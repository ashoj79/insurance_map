import 'package:dio/dio.dart';
import 'package:insurance_map/data/remote/api_service/insurance_api_service.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/utils/data_state.dart';

class InsuranceRepository {
  final InsuranceApiService _apiService;
  InsuranceRepository(this._apiService);

  Future<DataState<List<InsuranceCompany>>> getInsuranceCampanies() async {
    try {
      var response = await _apiService.getCompanies();
      List<InsuranceCompany> data = List.generate(response.data['data'].length, (index) => InsuranceCompany.fromJson(response.data['data'][index]));
      return DataSucces(data);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> saveInsuranceOffice(int provinceId, int cityId, String insuranceCompanyId, String officeName, String officeCode, String address, String postalCode, String lat, String lng) async {
    try {
      await _apiService.saveInsuranceOffice(provinceId, cityId, insuranceCompanyId, officeName, officeCode, address, postalCode, lat, lng);
      return DataSucces();
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }
}