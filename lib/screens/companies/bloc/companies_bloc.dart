import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/repo/main_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'companies_event.dart';
part 'companies_state.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final MainRepository _repository;
  CompaniesBloc(this._repository) : super(CompaniesInitial()) {
    on<CompaniesEvent>((event, emit) async {
      emit(CompaniesLoading());

      DataState<List<InsuranceCompany>> result = await _repository.getCompanies();

      emit(result is DataError ? CompaniesError(result.errorMessage!) : CompaniesShow(result.data!));
    });
  }
}
