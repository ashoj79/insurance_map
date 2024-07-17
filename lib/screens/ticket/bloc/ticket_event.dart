part of 'ticket_bloc.dart';

@immutable
sealed class TicketEvent {}

class TicketSend extends TicketEvent {
  final String title, message, priority;
  TicketSend({required this.title, required this.message, required this.priority});
}