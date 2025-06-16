part of 'insurance_request_bloc.dart';

@immutable
sealed class InsuranceRequestState {}

final class InsuranceRequestInitial extends InsuranceRequestState {}

class InsuranceRequestLoading extends InsuranceRequestState {}

class InsuranceRequestError extends InsuranceRequestState {
  final String message;
  InsuranceRequestError(this.message);
}

class InsuranceRequestShowData extends InsuranceRequestState {
  final List<Vehicle> vehicles;
  final List<InsuranceCompany> companies;
  InsuranceRequestShowData(this.vehicles, this.companies);
}