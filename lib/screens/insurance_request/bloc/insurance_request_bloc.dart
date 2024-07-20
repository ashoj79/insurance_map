import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/vehicle.dart';
import 'package:insurance_map/repo/vehicles_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'insurance_request_event.dart';
part 'insurance_request_state.dart';

class InsuranceRequestBloc extends Bloc<InsuranceRequestEvent, InsuranceRequestState> {
  final VehiclesRepository _repository;

  InsuranceRequestBloc(this._repository) : super(InsuranceRequestInitial()) {
    on<InsuranceRequestGetVehicles>((event, emit) async {
      emit(InsuranceRequestLoading());

      DataState<List<Vehicle>> result = await _repository.getVehicles();

      emit(result is DataSucces ? InsuranceRequestShowVehicles(result.data!) : InsuranceRequestError(result.errorMessage!));
    });
    
    on<InsuranceRequestSend>((event, emit) async {
      if (event.id.isEmpty) {
        emit(InsuranceRequestError('لطفا وسیله نقلیه مورد نظر را انتخاب کنید'));
        return;
      }
      if (event.description.isEmpty) {
        emit(InsuranceRequestError('لطفا توضیحات را وارد کنید'));
        return;
      }
      
      emit(InsuranceRequestLoading());
      
      DataState<void> result = await _repository.saveRequest(event.id, event.description);
      
      emit(InsuranceRequestError(result is DataError ? result.errorMessage! : 'درخواست شما ثبت شد'));
    });
  }
}
