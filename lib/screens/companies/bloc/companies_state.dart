part of 'companies_bloc.dart';

@immutable
sealed class CompaniesState {}

final class CompaniesInitial extends CompaniesState {}

class CompaniesLoading extends CompaniesState {}

class CompaniesError extends CompaniesState {
  final String message;
  CompaniesError(this.message);
}

class CompaniesShow extends CompaniesState {
  final List<InsuranceCompany> companies;
  CompaniesShow(this.companies);
}