import 'package:bloc/bloc.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/data/remote/model/category.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/data/remote/model/slider_model.dart';
import 'package:insurance_map/repo/main_repository.dart';
import 'package:insurance_map/repo/user_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final MainRepository _repository;
  final UserRepository _userRepository;

  MainBloc(this._repository, this._userRepository) : super(MainInitial()) {
    on<MainGetData>((event, emit) async {
      emit(MainLoading());

      DataState<List<SliderModel>> sliders = await _repository.getSliders();
      if (sliders is DataError){
        emit(MainError(sliders.errorMessage!));
        return;
      }

      DataState<List<Category>> categories = await _repository.getTopCategories();
      if (categories is DataError){
        emit(MainError(categories.errorMessage!));
        return;
      }

      DataState<List<InsuranceCompany>> companies = await _repository.getTopCompanies();
      if (companies is DataError){
        emit(MainError(companies.errorMessage!));
        return;
      }

      await _repository.getMessages();
      await _repository.getPageContent('about-us');
      await _repository.getPageContent('terms');
      await _userRepository.updateWalletBalance();

      emit(MainDataReceived(sliders: sliders.data!, categories: categories.data!, companies: companies.data!));
    });

    on<MainGoToBankCards>((event, emit) {
      if (!_userRepository.isUserLoggedIn()) {
        emit(MainError('ابتدا وارد اکانت خود شود'));
        return;
      }

      AppNavigator.push(Routes.cardsAndVehiclesRoute);
    });
  }
}
