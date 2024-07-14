part of 'map_bloc.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapShowPositions extends MapState {
  final List<MapPositionData> positions;
  MapShowPositions(this.positions);
}

class MapShowProvinces extends MapState {
  final List<ProvinceAndCity> provinces;
  MapShowProvinces(this.provinces);
}

class MapShowCities extends MapState {
  final List<ProvinceAndCity> cities;
  MapShowCities(this.cities);
}