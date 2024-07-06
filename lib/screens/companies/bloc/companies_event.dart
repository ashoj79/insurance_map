part of 'companies_bloc.dart';

@immutable
sealed class CompaniesEvent {}

class CompaniesGetData extends CompaniesEvent {}