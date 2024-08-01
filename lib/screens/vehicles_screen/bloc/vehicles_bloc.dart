import 'package:bloc/bloc.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/data/remote/model/vehicle_info.dart';
import 'package:insurance_map/repo/vehicles_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final VehiclesRepository _repository;
  List<String> _savedLicenses = [];

  VehiclesBloc(this._repository) : super(VehiclesInitial()) {
    on<VehiclesGetTypes>((event, emit) async {
      emit(VehiclesLoading());
      DataState<List<VehicleInfo>> result = await _repository.getCarTypes();
      if (result is DataError){
        emit(VehiclesError(result.errorMessage!));
        return;
      }

      _savedLicenses = (await _repository.getVehiclesLicense()).data ?? [];
      
      emit(VehiclesUpdateTypes(types: result.data!));
    });

    on<VehiclesGetBrands>((event, emit) async {
      emit(VehiclesLoading());
      DataState<List<VehicleInfo>> result = await _repository.getCarBrands(event.typeId);
      emit(result is DataError ? VehiclesError(result.errorMessage!) : VehiclesUpdateBrands(brands: result.data!));
    });

    on<VehiclesGetModels>((event, emit) async {
      emit(VehiclesLoading());
      DataState<List<VehicleInfo>> result = await _repository.getCarModels(event.typeId, event.brandId);
      emit(result is DataError ? VehiclesError(result.errorMessage!) : VehiclesUpdateModels(models: result.data!));
    });

    on<VehiclesSave>((event, emit) async {
      String type = event.type == 1 ? 'car' : 'motorcycle', license = event.license;
      if ((type == 'car' && license.length != 10 && license.length != 8) || (type == 'motorcycle' && license.length != 8)) {
        emit(VehiclesError('پلاک وسیله نقلیه را وارد کنید'));
        return;
      }

      if (type == 'car' && event.carTypeId == 0) {
        emit(VehiclesError('نوع ماشین را انتخاب کنید'));
        return;
      }

      if (type == 'car' && event.carBrandId == 0) {
        emit(VehiclesError('برند ماشین را انتخاب کنید'));
        return;
      }

      if (type == 'car' && event.carModelId == 0) {
        emit(VehiclesError('مدل ماشین را انتخاب کنید'));
        return;
      }

      if (event.thirdPartyInsurance && event.thirdPartyInsuranceDate.isEmpty) {
        emit(VehiclesError('تاریخ اتمام بیمه شخص ثالث را وارد کنید'));
        return;
      }

      if (event.carBodyInsurance && event.carBodyInsuranceDate.isEmpty) {
        emit(VehiclesError('تاریخ اتمام بیمه بدنه را وارد کنید'));
        return;
      }

      if (_savedLicenses.contains(license)) {
        emit(VehiclesError('این پلاک قبلا ثبت شده است'));
        return;
      }
      
      DataState<void> result = await _repository.saveVehicle(
        type,
        license,
        event.carTypeId,
        event.carBrandId,
        event.carModelId,
        event.thirdPartyInsurance,
        event.thirdPartyInsuranceDate,
        event.carBodyInsurance,
        event.carBodyInsuranceDate
      );

      emit(result is DataError ? VehiclesError(result.errorMessage!) : VehiclesSaved());
    });

    on<VehiclesSubmit>((event, emit) => emit(VehiclesSubmitted()));
  }
}
