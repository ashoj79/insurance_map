part of 'vehicles_bloc.dart';

@immutable
sealed class VehiclesState {}

final class VehiclesInitial extends VehiclesState {}

class VehiclesLoading extends VehiclesState {}

class VehiclesError extends VehiclesState {
  final String message;
  VehiclesError(this.message);
}

class VehiclesNewCar extends VehiclesState {
  final List<VehicleInfo> types;
  VehiclesNewCar(this.types);
}

class VehiclesUpdateBrands extends VehiclesState {
  final List<VehicleInfo> brands;
  final String instanceId;
  VehiclesUpdateBrands({required this.brands, required this.instanceId});
}

class VehiclesUpdateModels extends VehiclesState {
  final List<VehicleInfo> models;
  final String instanceId;
  VehiclesUpdateModels({required this.models, required this.instanceId});
}

class VehiclesSaved extends VehiclesState {
  final String instanceId;
  VehiclesSaved(this.instanceId);
}

class VehiclesShowAlert extends VehiclesState {}