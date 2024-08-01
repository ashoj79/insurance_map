part of 'c_a_v_bloc.dart';

@immutable
sealed class CAVState {}

final class CAVInitial extends CAVState {}

class CAVLoading extends CAVState {}

class CAVError extends CAVState {
  final String message;
  CAVError(this.message);
}

class CAVShowData extends CAVState {
  final Map<String, Bank> cards;
  final List<String> vehicles;
  CAVShowData({required this.cards, required this.vehicles});
}