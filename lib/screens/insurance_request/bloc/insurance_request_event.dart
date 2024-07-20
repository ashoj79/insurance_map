part of 'insurance_request_bloc.dart';

@immutable
sealed class InsuranceRequestEvent {}

class InsuranceRequestGetVehicles extends InsuranceRequestEvent {}

class InsuranceRequestSend extends InsuranceRequestEvent {
  final String id, description;
  InsuranceRequestSend({required this.id, required this.description});
}