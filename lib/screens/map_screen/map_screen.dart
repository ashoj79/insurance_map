import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';

class MapWithPopups extends StatefulWidget {
  @override
  _MapWithPopupsState createState() => _MapWithPopupsState();
}

class _MapWithPopupsState extends State<MapWithPopups> {
  final List<Marker> _markers = [];
  final PopupController _popupController = PopupController();

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        point: LatLng(35.6892, 51.3890),
        child:GestureDetector(
          onTap: () {
            _popupController.togglePopup(_markers[0]);
          },
          child: Icon(Icons.location_on, color: Colors.red, size: 48,)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(35.6892, 51.3890),
        initialZoom: 16.0,
        onTap: (_, __) => _popupController.hideAllPopups(),
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
  }
}