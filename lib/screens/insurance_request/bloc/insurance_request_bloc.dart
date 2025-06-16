import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/data/remote/model/vehicle.dart';
import 'package:insurance_map/repo/insurance_repository.dart';
import 'package:insurance_map/repo/vehicles_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'insurance_request_event.dart';
part 'insurance_request_state.dart';

class InsuranceRequestBloc extends Bloc<InsuranceRequestEvent, InsuranceRequestState> {
  final VehiclesRepository _repository;
  final InsuranceRepository _insuranceRepository;

  InsuranceRequestBloc(this._repository, this._insuranceRepository) : super(InsuranceRequestInitial()) {
    on<InsuranceRequestGetData>((event, emit) async {
      emit(InsuranceRequestLoading());

      DataState<List<Vehicle>> result = await _repository.getVehicles();
      DataState<List<InsuranceCompany>> companies = await _insuranceRepository.getInsuranceCampanies();

      emit(result is DataSucces ? InsuranceRequestShowData(result.data!, companies.data!) : InsuranceRequestError(result.errorMessage!));
    });
    
    on<InsuranceRequestSend>((event, emit) async {
      if (event.id.isEmpty) {
        emit(InsuranceRequestError('لطفا وسیله نقلیه مورد نظر را انتخاب کنید'));
        return;
      }
      if (event.companyId.isEmpty) {
        emit(InsuranceRequestError('لطفا شرکت بیمه مورد نظر را انتخاب کنید'));
        return;
      }
      if (event.insuranceType.isEmpty) {
        emit(InsuranceRequestError('لطفا نوع بیمه مورد نظر را انتخاب کنید'));
        return;
      }
      if (event.date.isEmpty) {
        emit(InsuranceRequestError('لطفا تاریخ انقضا را وارد کنید'));
        return;
      }
      if (event.description.isEmpty) {
        emit(InsuranceRequestError('لطفا توضیحات را وارد کنید'));
        return;
      }
      
      emit(InsuranceRequestLoading());
      
      DataState<void> result = await _repository.saveRequest(event.id, event.description, event.companyId, event.insuranceType, event.date);
      
      emit(InsuranceRequestError(result is DataError ? result.errorMessage! : 'درخواست شما ثبت شد'));
    });
  }
}
