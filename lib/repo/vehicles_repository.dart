import 'package:dio/dio.dart';
import 'package:insurance_map/data/remote/api_service/vehicles_api_service.dart';
import 'package:insurance_map/data/remote/model/vehicle.dart';
import 'package:insurance_map/data/remote/model/vehicle_info.dart';
import 'package:insurance_map/utils/data_state.dart';

class VehiclesRepository {
  final VehiclesApiService _apiService;
  VehiclesRepository(this._apiService);

  Future<DataState<List<Vehicle>>> getVehicles() async {
    try{
      var response = await _apiService.getUserVehicles();
      List<Vehicle> data = List.generate(response.data['data'].length, (index) => Vehicle.fromJson(response.data['data'][index]));
      return DataSucces(data);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<List<VehicleInfo>>> getCarTypes() async {
    try{
      var response = await _apiService.getCarTypes();
      List<VehicleInfo> data = List.generate(response.data['data'].length, (index) => VehicleInfo.fromJson(response.data['data'][index]));
      return DataSucces(data);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<List<VehicleInfo>>> getCarBrands(int typeId) async {
    try{
      var response = await _apiService.getCarBrands(typeId);
      List<VehicleInfo> data = List.generate(response.data['data'].length, (index) => VehicleInfo.fromJson(response.data['data'][index]));
      return DataSucces(data);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<List<VehicleInfo>>> getCarModels(int typeId, int brandId) async {
    try{
      var response = await _apiService.getCarModels(typeId, brandId);
      List<VehicleInfo> data = List.generate(response.data['data'].length, (index) => VehicleInfo.fromJson(response.data['data'][index]));
      return DataSucces(data);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> saveVehicle(String type, String license, int carTypeId, int carBrandId, int carModelId, bool thirdPartyInsurance, String thirdPartyInsuranceDate, bool carBodyInsurance, String carBodyInsuranceDate) async {
    try{
      await _apiService.saveVehicle(type, license, carTypeId, carBrandId, carModelId, thirdPartyInsurance, thirdPartyInsuranceDate, carBodyInsurance, carBodyInsuranceDate);
      return DataSucces();
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<List<String>>> getVehiclesLicense() async {
    try{
      var response = await _apiService.getUserVehicles();
      List<String> licenses = List.generate(response.data['data'].length, (index) => response.data['data'][index]['license_plate']);
      return DataSucces(licenses);
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }

  Future<DataState<void>> saveRequest(String id, String description, String companyId, String type, String date) async {
    try{
      await _apiService.saveRequest(id, description, companyId, type, date);
      return DataSucces();
    } on DioException catch (e) {
      return DataError(e.response?.data?.toString() ?? '');
    } catch (_) {
      return DataError('مشکلی رخ داد لطفا مجدد امتحان کنید');
    }
  }
}