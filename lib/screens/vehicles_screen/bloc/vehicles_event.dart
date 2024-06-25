part of 'vehicles_bloc.dart';

@immutable
sealed class VehiclesEvent {}

class VehiclesGetTypes extends VehiclesEvent {}

class VehiclesAddNew extends VehiclesEvent {}

class VehiclesGetBrands extends VehiclesEvent {
  final int typeId;
  final String instanceId;
  VehiclesGetBrands({required this.instanceId, required this.typeId});
}

class VehiclesGetModels extends VehiclesEvent {
  final int typeId, brandId;
  final String instanceId;
  VehiclesGetModels(
      {required this.instanceId, required this.typeId, required this.brandId});
}

class VehiclesSave extends VehiclesEvent {
  final VehiclesInfoController controller;
  VehiclesSave({required this.controller});
}

class VehiclesSubmit extends VehiclesEvent {}
