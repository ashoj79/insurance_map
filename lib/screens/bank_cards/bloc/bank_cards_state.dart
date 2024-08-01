part of 'bank_cards_bloc.dart';

@immutable
sealed class BankCardsState {}

final class BankCardsInitial extends BankCardsState {}

class BankCardsLoading extends BankCardsState {}

class BankCardsError extends BankCardsState {
  final String message;
  BankCardsError(this.message);
}

class BankCardsShowNumbers extends BankCardsState {
  final Map<String, Bank> numbers;
  BankCardsShowNumbers(this.numbers);
}

class BankCardsUpdateCard extends BankCardsState {
  final Bank? bank;
  BankCardsUpdateCard({this.bank});
}

class BankCardSaved extends BankCardsState {
  final Bank bank;
  BankCardSaved(this.bank);
}

class BankCardsOpenGateway extends BankCardsState {
  final CardPaymentInfo info;
  BankCardsOpenGateway(this.info);
}

class BankCardsDone extends BankCardsState {}