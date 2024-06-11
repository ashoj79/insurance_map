import 'package:get_it/get_it.dart';
import 'package:insurance_map/config/dio_helper.dart';
import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/data/remote/api_service/user_api_service.dart';
import 'package:insurance_map/repo/user_repository.dart';
import 'package:insurance_map/screens/signup/bloc/signup_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

var locator = GetIt.instance;

Future<void> setup() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  DioHelper dioHelper = DioHelper();

  locator.registerSingleton(SharedPrefereceHelper(sharedPreferences));
  locator.registerSingleton(dioHelper.dio);

  //api services
  locator.registerSingleton(UserApiService(locator()));

  //repositories
  locator.registerSingleton(UserRepository(locator(), locator()));

  //bloc
  locator.registerSingleton(SignupBloc(locator()));
}