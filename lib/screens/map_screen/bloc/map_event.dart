part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}

class MapGetPositions extends MapEvent {
  final String type, id;
  final double fromLat, fromLng, toLat, toLng;
  MapGetPositions({required this.type, required this.id, required this.fromLat, required this.fromLng, required this.toLat, required this.toLng});
}

class MapGetProvinces extends MapEvent {}

class MapGetCities extends MapEvent {
  final int provinceId;
  MapGetCities(this.provinceId);
}