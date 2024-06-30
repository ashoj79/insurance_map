part of 'vehicles_bloc.dart';

@immutable
sealed class VehiclesEvent {}

class VehiclesGetTypes extends VehiclesEvent {}

class VehiclesGetBrands extends VehiclesEvent {
  final int typeId;
  VehiclesGetBrands({required this.typeId});
}

class VehiclesGetModels extends VehiclesEvent {
  final int typeId, brandId;
  VehiclesGetModels({required this.typeId, required this.brandId});
}

class VehiclesSave extends VehiclesEvent {
  final int type, carTypeId, carModelId, carBrandId;
  final String license, thirdPartyInsuranceDate, carBodyInsuranceDate;
  final bool thirdPartyInsurance, carBodyInsurance;
  VehiclesSave(
      {required this.type,
      required this.carTypeId,
      required this.carBrandId,
      required this.carModelId,
      required this.license,
      required this.thirdPartyInsurance,
      required this.carBodyInsurance,
      required this.carBodyInsuranceDate,
      required this.thirdPartyInsuranceDate});
}

class VehiclesSubmit extends VehiclesEvent {}
