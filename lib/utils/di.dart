import 'package:get_it/get_it.dart';
import 'package:insurance_map/config/dio_helper.dart';
import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/data/remote/api_service/bank_api_service.dart';
import 'package:insurance_map/data/remote/api_service/insurance_api_service.dart';
import 'package:insurance_map/data/remote/api_service/main_api_service.dart';
import 'package:insurance_map/data/remote/api_service/place_api_service.dart';
import 'package:insurance_map/data/remote/api_service/shop_api_service.dart';
import 'package:insurance_map/data/remote/api_service/social_api_service.dart';
import 'package:insurance_map/data/remote/api_service/user_api_service.dart';
import 'package:insurance_map/data/remote/api_service/vehicles_api_service.dart';
import 'package:insurance_map/repo/bank_repository.dart';
import 'package:insurance_map/repo/insurance_repository.dart';
import 'package:insurance_map/repo/main_repository.dart';
import 'package:insurance_map/repo/place_repository.dart';
import 'package:insurance_map/repo/shop_repository.dart';
import 'package:insurance_map/repo/social_repository.dart';
import 'package:insurance_map/repo/user_repository.dart';
import 'package:insurance_map/repo/vehicles_repository.dart';
import 'package:insurance_map/screens/bank_cards/bloc/bank_cards_bloc.dart';
import 'package:insurance_map/screens/cards_and_vehicles/bloc/c_a_v_bloc.dart';
import 'package:insurance_map/screens/categories/bloc/categories_bloc.dart';
import 'package:insurance_map/screens/companies/bloc/companies_bloc.dart';
import 'package:insurance_map/screens/content_view/bloc/content_view_bloc.dart';
import 'package:insurance_map/screens/insurance_request/bloc/insurance_request_bloc.dart';
import 'package:insurance_map/screens/main/bloc/main_bloc.dart';
import 'package:insurance_map/screens/map_screen/bloc/map_bloc.dart';
import 'package:insurance_map/screens/shop_details/bloc/shop_details_bloc.dart';
import 'package:insurance_map/screens/signup/bloc/signup_bloc.dart';
import 'package:insurance_map/screens/social_responsibilities/bloc/s_r_bloc.dart';
import 'package:insurance_map/screens/sr_details/bloc/sr_details_bloc.dart';
import 'package:insurance_map/screens/ticket/bloc/ticket_bloc.dart';
import 'package:insurance_map/screens/vehicles_screen/bloc/vehicles_bloc.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

var locator = GetIt.instance;

Future<void> setup() async {
  var sharedPreferences = await StreamingSharedPreferences.instance;
  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper(sharedPreferences);
  DioHelper dioHelper = DioHelper(sharedPreferenceHelper);

  locator.registerSingleton(sharedPreferenceHelper);
  locator.registerSingleton(dioHelper.dio);

  //api services
  locator.registerSingleton(UserApiService(locator()));
  locator.registerSingleton(InsuranceApiService(locator()));
  locator.registerSingleton(PlaceApiService(locator()));
  locator.registerSingleton(ShopApiService(locator()));
  locator.registerSingleton(VehiclesApiService(locator()));
  locator.registerSingleton(BankApiService(locator()));
  locator.registerSingleton(MainApiService(locator()));
  locator.registerSingleton(SocialApiService(locator()));

  //repositories
  locator.registerSingleton(UserRepository(locator(), locator()));
  locator.registerSingleton(InsuranceRepository(locator()));
  locator.registerSingleton(PlaceRepository(locator()));
  locator.registerSingleton(ShopRepository(locator()));
  locator.registerSingleton(VehiclesRepository(locator()));
  locator.registerSingleton(BankRepository(locator()));
  locator.registerSingleton(MainRepository(locator()));
  locator.registerSingleton(SocialRepository(locator()));

  //bloc
  locator.registerSingleton(SignupBloc(locator(), locator(), locator(), locator()));
  locator.registerSingleton(VehiclesBloc(locator()));
  locator.registerSingleton(BankCardsBloc(locator(), locator()));
  locator.registerSingleton(MainBloc(locator(), locator()));
  locator.registerSingleton(CategoriesBloc(locator()));
  locator.registerSingleton(CompaniesBloc(locator()));
  locator.registerSingleton(MapBloc(locator(), locator(), locator()));
  locator.registerSingleton(ContentViewBloc(locator()));
  locator.registerSingleton(TicketBloc(locator()));
  locator.registerSingleton(CAVBloc(locator(), locator()));
  locator.registerSingleton(InsuranceRequestBloc(locator(), locator()));
  locator.registerSingleton(SRBloc(locator(), locator()));
  locator.registerSingleton(SrDetailsBloc(locator()));
  locator.registerSingleton(ShopDetailsBloc(locator(), locator()));
}