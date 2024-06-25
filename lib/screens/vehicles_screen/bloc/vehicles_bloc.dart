import 'package:bloc/bloc.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/data/remote/model/vehicle_info.dart';
import 'package:insurance_map/repo/vehicles_repository.dart';
import 'package:insurance_map/screens/vehicles_screen/vehicles_screen.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final VehiclesRepository _repository;
  List<VehicleInfo> types = [];
  int vehiclesCount = 0, savedCount = 0;

  VehiclesBloc(this._repository) : super(VehiclesInitial()) {
    on<VehiclesGetTypes>((event, emit) async {
      emit(VehiclesLoading());
      DataState<List<VehicleInfo>> result = await _repository.getCarTypes();
      if (result is DataError){
        emit(VehiclesError(result.errorMessage!));
        return;
      }
      types = result.data!;
      emit(VehiclesInitial());
    });

    on<VehiclesAddNew>((event, emit) {
      vehiclesCount++;
      emit(VehiclesNewCar(types));
    });

    on<VehiclesGetBrands>((event, emit) async {
      emit(VehiclesLoading());
      DataState<List<VehicleInfo>> result = await _repository.getCarBrands(event.typeId);
      emit(result is DataError ? VehiclesError(result.errorMessage!) : VehiclesUpdateBrands(brands: result.data!, instanceId: event.instanceId));
    });

    on<VehiclesGetModels>((event, emit) async {
      emit(VehiclesLoading());
      DataState<List<VehicleInfo>> result = await _repository.getCarModels(event.typeId, event.brandId);
      emit(result is DataError ? VehiclesError(result.errorMessage!) : VehiclesUpdateModels(models: result.data!, instanceId: event.instanceId));
    });

    on<VehiclesSave>((event, emit) async {
      String type = event.controller.type == 1 ? 'car' : 'motorcycle', license = event.controller.getLicense();
      if ((type == 'car' && license.length != 10 && license.length != 8) || (type == 'motorcycle' && license.length != 8)) {
        emit(VehiclesError('پلاک وسیله نقلیه را وارد کنید'));
        return;
      }

      if (type == 'car' && event.controller.carTypeId == 0) {
        emit(VehiclesError('نوع ماشین را انتخاب کنید'));
        return;
      }

      if (type == 'car' && event.controller.carBrandId == 0) {
        emit(VehiclesError('برند ماشین را انتخاب کنید'));
        return;
      }

      if (type == 'car' && event.controller.carModelId == 0) {
        emit(VehiclesError('مدل ماشین را انتخاب کنید'));
        return;
      }

      if (event.controller.thirdPartyInsurance && event.controller.thirdPartyInsuranceDate.text.isEmpty) {
        emit(VehiclesError('تاریخ اتمام بیمه شخص ثالث را وارد کنید'));
        return;
      }

      if (event.controller.carBodyInsurance && event.controller.carBodyInsuranceDate.text.isEmpty) {
        emit(VehiclesError('تاریخ اتمام بیمه بدنه را وارد کنید'));
        return;
      }
      
      DataState<void> result = await _repository.saveVehicle(
        type,
        license,
        event.controller.carTypeId,
        event.controller.carBrandId,
        event.controller.carModelId,
        event.controller.thirdPartyInsurance,
        event.controller.thirdPartyInsuranceDate.text,
        event.controller.carBodyInsurance,
        event.controller.carBodyInsuranceDate.text
      );

      if (result is DataSucces) savedCount++;

      emit(result is DataError ? VehiclesError(result.errorMessage!) : VehiclesSaved(event.controller.id));
    });

    on<VehiclesSubmit>((event, emit) {
      if (vehiclesCount > savedCount) {
        emit(VehiclesShowAlert());
        return;
      }

      AppNavigator.push(Routes.bankCardsRoute, popTo: Routes.vehiclesRoute);
    });
  }
}
