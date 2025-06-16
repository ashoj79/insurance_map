import 'package:bloc/bloc.dart';
import 'package:insurance_map/repo/shop_repository.dart';
import 'package:insurance_map/repo/user_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'shop_details_event.dart';
part 'shop_details_state.dart';

class ShopDetailsBloc extends Bloc<ShopDetailsEvent, ShopDetailsState> {
  final ShopRepository _shopRepository;
  final UserRepository _userRepository;

  ShopDetailsBloc(this._shopRepository, this._userRepository) : super(ShopDetailsInitial()) {
    on<ShopDetailsCreateRequest>((event, emit) async {
      if (!_userRepository.isUserLoggedIn()) {
        emit(ShopDetailsMessage(message: 'لطفا ابتدا وارد اکانت خود شوید'));
        return;
      }

      if (int.tryParse(event.amount) == null) {
        emit(ShopDetailsMessage(message: 'لطفاد مبلغ را وارد کنید'));
        return;
      }

      emit(ShopDetailsLoading());
      DataState<void> result = await _shopRepository.createCashRequest(int.parse(event.amount), event.vendorId);
      emit(ShopDetailsMessage(message: result is DataError ? result.errorMessage! : 'نتیجه برای شما پیامک خواهد شد'));
    });
  }
}
