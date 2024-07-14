part of 'bank_cards_bloc.dart';

@immutable
sealed class BankCardsEvent {}

class BankCardsGetData extends BankCardsEvent {}

class BankCardsSubmit extends BankCardsEvent {}

class BankCardCheckNumber extends BankCardsEvent {
  final String cardNumber;
  BankCardCheckNumber({required this.cardNumber});
}

class BankCardSaveCard extends BankCardsEvent {
  final String cardNumber;
  BankCardSaveCard({required this.cardNumber});
}