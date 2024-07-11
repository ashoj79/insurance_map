import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:insurance_map/data/remote/model/map_position.dart';
import 'package:insurance_map/screens/map_screen/bloc/map_bloc.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Marker> _markers = [];
  final PopupController _popupController = PopupController();
  final MapController _mapController = MapController();

  String type = '', id = '';

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      _fetchPositions();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> data = ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, String>;
    type = data['type']!;
    id = data['id']!;

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is MapShowPositions) _addMarker(state.positions);

        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(35.6892, 51.3890),
            initialZoom: 9.0,
            onTap: (_, __) {
              _popupController.hideAllPopups();
            },
            onPositionChanged: (position, hasGesture) {
              if (hasGesture) _fetchPositions();
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: _markers,
            ),
            PopupMarkerLayer(
              options: PopupMarkerLayerOptions(
                  markers: _markers,
                  popupController: _popupController,
                  popupDisplayOptions: PopupDisplayOptions(
                    builder: (BuildContext context, Marker marker) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('اطلاعات این نقطه: ${marker.point.latitude}, ${marker.point.longitude}'),
                        ),
                      );
                    },
                  )
              ),
            )
          ],
        );
      },
    );
  }

  _addMarker(List<MapPositionData> positions) {
    _markers.clear();
    for (MapPositionData pos in positions){
      _markers.add(
        Marker(
          point: LatLng(pos.lat, pos.lng),
          child: GestureDetector(
              onTap: () {
                _popupController.togglePopup(_markers[0]);
              },
              child: const Icon(Icons.location_on, color: Colors.red, size: 48,)),
        ),
      );
    }
  }

  _fetchPositions() {
    BlocProvider.of<MapBloc>(context).add(MapGetPositions(type: type,
        id: id,
        fromLat: _mapController.camera.visibleBounds.southWest.latitude,
        fromLng: _mapController.camera.visibleBounds.southWest.longitude,
        toLat: _mapController.camera.visibleBounds.northEast.latitude,
        toLng: _mapController.camera.visibleBounds.northEast.longitude));
  }
}