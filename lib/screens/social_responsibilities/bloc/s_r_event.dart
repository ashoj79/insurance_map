part of 's_r_bloc.dart';

@immutable
sealed class SREvent {}

class SRGetInitData extends SREvent {}

class SRGetProvinceData extends SREvent {
  final int provinceId;
  SRGetProvinceData(this.provinceId);
}

class SRGetCityData extends SREvent {
  final int cityId;
  SRGetCityData(this.cityId);
}