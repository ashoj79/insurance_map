import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/bank.dart';
import 'package:insurance_map/data/remote/model/card_payment_info.dart';
import 'package:insurance_map/repo/bank_repository.dart';
import 'package:insurance_map/repo/user_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'bank_cards_event.dart';
part 'bank_cards_state.dart';

class BankCardsBloc extends Bloc<BankCardsEvent, BankCardsState> {
  final BankRepository _repository;
  final UserRepository _userRepository;

  final List<Bank> _banks = [];
  final List<String> _savedCarts = [];

  BankCardsBloc(this._repository, this._userRepository) : super(BankCardsInitial()) {
    on<BankCardsGetData>((event, emit) async {
      emit(BankCardsLoading());
      DataState<List<Bank>> result = await _repository.getBanks();
      if (result is DataError) {
        emit(BankCardsError(result.errorMessage!));
        return;
      }

      _banks.clear();
      _banks.addAll(result.data!);
      _savedCarts.clear();

      DataState<List<String>> result1 = await _repository.getUserCards();

      Map<String, Bank> data = {};
      if (result1 is DataSucces) {
        for (String num in result1.data!){
          int bankIndex = _banks.indexWhere((element) => element.prefixs.contains(num.substring(0, 6)));
          data.addAll({num: _banks[bankIndex]});
          _savedCarts.add(num);
        }
      }

      emit(BankCardsShowNumbers(data));
    });

    on<BankCardCheckNumber>((event, emit) {
      if (event.cardNumber.startsWith('-') ||
          event.cardNumber.replaceAll('-', '').length != 6) return;
      String number = event.cardNumber.replaceAll('-', '');
      int index =
          _banks.indexWhere((element) => element.prefixs.contains(number));
      if (index > -1) {
        emit(BankCardsUpdateCard(bank: _banks[index]));
      } else {
        emit(BankCardsUpdateCard());
      }
    });

    on<BankCardSaveCard>((event, emit) async {
      if (event.cardNumber.length != 16) {
        emit(BankCardsError('شماره کارت خود را وارد کنید'));
        return;
      }

      if (_savedCarts.contains(event.cardNumber)) {
        emit(BankCardsError('شماره کارت قبلا ثبت شده است'));
        return;
      }

      emit(BankCardsLoading());

      DataState<void> result = await _repository.addCard(event.cardNumber);

      if (result is DataSucces) _savedCarts.add(event.cardNumber);

      int bankIndex = _banks.indexWhere((element) => element.prefixs.contains(event.cardNumber.substring(0, 6)));

      emit(result is DataError ? BankCardsError(result.errorMessage!) : BankCardSaved(_banks[bankIndex]));
    });

    on<BankCardsSubmit>((event, emit) async {
      emit(BankCardsLoading());

      DataState<CardPaymentInfo> result = await _repository.getPaymentUrl();

      if (result is DataError) {
        emit(BankCardsError(result.errorMessage!));
        return;
      }

      if (result.data!.amount == 0){
        await _userRepository.updateWalletBalance();
        emit(BankCardsDone());
        return;
      }

      emit(BankCardsOpenGateway(result.data!));
    });
  }
}
