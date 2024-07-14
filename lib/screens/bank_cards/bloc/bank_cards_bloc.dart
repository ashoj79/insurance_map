import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/bank.dart';
import 'package:insurance_map/data/remote/model/card_payment_info.dart';
import 'package:insurance_map/repo/bank_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'bank_cards_event.dart';
part 'bank_cards_state.dart';

class BankCardsBloc extends Bloc<BankCardsEvent, BankCardsState> {
  final BankRepository _repository;
  final List<Bank> _banks = [];

  BankCardsBloc(this._repository) : super(BankCardsInitial()) {
    on<BankCardsGetData>((event, emit) async {
      emit(BankCardsLoading());
      DataState<List<Bank>> result = await _repository.getBanks();
      if (result is DataError) {
        emit(BankCardsError(result.errorMessage!));
        return;
      }

      _banks.clear();
      _banks.addAll(result.data!);

      DataState<List<String>> result1 = await _repository.getUserCards();

      emit(BankCardsShowNumbers(result1.data ?? []));
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

      emit(BankCardsLoading());

      DataState<void> result = await _repository.addCard(event.cardNumber);

      emit(result is DataError ? BankCardsError(result.errorMessage!) : BankCardSaved());
    });

    on<BankCardsSubmit>((event, emit) async {
      emit(BankCardsLoading());

      DataState<CardPaymentInfo> result = await _repository.getPaymentUrl();

      if (result is DataError) {
        emit(BankCardsError(result.errorMessage!));
        return;
      }

      if (result.data!.amount == 0){
        emit(BankCardsDone());
        return;
      }

      emit(BankCardsOpenGateway(result.data!));
    });
  }
}
