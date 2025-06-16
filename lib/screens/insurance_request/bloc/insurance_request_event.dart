part of 'insurance_request_bloc.dart';

@immutable
sealed class InsuranceRequestEvent {}

class InsuranceRequestGetData extends InsuranceRequestEvent {}

class InsuranceRequestSend extends InsuranceRequestEvent {
  final String id, companyId, insuranceType, date, description;
  InsuranceRequestSend({required this.id, required this.companyId, required this.date, required this.insuranceType, required this.description});
}