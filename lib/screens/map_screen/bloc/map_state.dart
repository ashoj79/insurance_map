part of 'map_bloc.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

class MapShowPositions extends MapState {
  final List<MapPositionData> positions;
  MapShowPositions(this.positions);
}
