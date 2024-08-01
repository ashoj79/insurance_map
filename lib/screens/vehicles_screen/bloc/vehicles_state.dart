part of 'vehicles_bloc.dart';

@immutable
sealed class VehiclesState {}

final class VehiclesInitial extends VehiclesState {}

class VehiclesLoading extends VehiclesState {}

class VehiclesError extends VehiclesState {
  final String message;
  VehiclesError(this.message);
}

class VehiclesUpdateTypes extends VehiclesState {
  final List<VehicleInfo> types;
  VehiclesUpdateTypes({required this.types});
}

class VehiclesUpdateBrands extends VehiclesState {
  final List<VehicleInfo> brands;
  VehiclesUpdateBrands({required this.brands});
}

class VehiclesUpdateModels extends VehiclesState {
  final List<VehicleInfo> models;
  VehiclesUpdateModels({required this.models});
}

class VehiclesSaved extends VehiclesState {}

class VehiclesSubmitted extends VehiclesState {}