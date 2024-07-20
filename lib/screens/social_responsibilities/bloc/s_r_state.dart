part of 's_r_bloc.dart';

@immutable
sealed class SRState {}

final class SRInitial extends SRState {}

class SRLoading extends SRState {}

class SRError extends SRState {
  final String message;
  SRError(this.message);
}

class SRShowProvinces extends SRState {
  final List<ProvinceAndCity> data;
  SRShowProvinces(this.data);
}

class SRShowCities extends SRState {
  final List<ProvinceAndCity> data;
  SRShowCities(this.data);
}

class SRShowResponsibilities extends SRState {
  final List<String> data;
  SRShowResponsibilities(this.data);
}