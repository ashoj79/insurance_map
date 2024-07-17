part of 'ticket_bloc.dart';

@immutable
sealed class TicketState {}

final class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketError extends TicketState {
  final String msg;
  TicketError(this.msg);
}

class TicketSuccess extends TicketState {}