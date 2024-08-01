import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/remote/model/map_position.dart';
import 'package:insurance_map/data/remote/model/province_city.dart';
import 'package:insurance_map/screens/map_screen/bloc/map_bloc.dart';
import 'package:insurance_map/utils/location_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Marker> _markers = [];
  final PopupController _popupController = PopupController();
  final MapController _mapController = MapController();
  final List<MapPositionData> _positions = [];
  final List<ProvinceAndCity> _provinces = [], _cities = [];

  String type = '', id = '';
  int selectedProvince = 0, selectedCity = 0;

  BuildContext? _alertContext;
  final Location _locationService = Location();
  Position? userLocation;

  @override
  void initState() {
    super.initState();
    _positions.clear();
    BlocProvider.of<MapBloc>(context).add(MapGetProvinces());

    Timer(const Duration(seconds: 1), () {
      _moveToUserLocation();
      _fetchPositions();
    });

    _mapController.mapEventStream.listen((event) { 
      if (event is MapEventMoveEnd || event is MapEventDoubleTapZoomEnd) {
        _fetchPositions();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Map<String, String> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    type = data['type']!;
    id = data['id']!;

    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state is MapLoading) {
          showWaitDialog(context, (p0) => _alertContext = p0);
        } else if (_alertContext != null) {
          Navigator.of(_alertContext!).pop();
          _alertContext = null;
        }
      },
      builder: (context, state) {
        if (state is MapShowPositions) {
          _positions.clear();
          _positions.addAll(state.positions);
          _addMarker();
        }

        if (state is MapShowProvinces) {
          _provinces.clear();
          _provinces.addAll(state.provinces);
        }

        if (state is MapShowCities) {
          _cities.clear();
          _cities.addAll(state.cities);
        }

        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(35.6892, 51.3890),
                initialZoom: 9.0,
                onTap: (_, __) {
                  _popupController.hideAllPopups();
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                              child: _getDialogWidget(marker),
                            ),
                          );
                        },
                      )),
                )
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 72,
              child: Row(
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: Colors.white,
                      child: DropdownButton(
                        value: selectedProvince,
                        items: [
                          const DropdownMenuItem(
                            value: 0,
                            child: Text('انتخاب استان'),
                          ),
                          for (var p in _provinces)
                            DropdownMenuItem(value: p.id, child: Text(p.name))
                        ],
                        onChanged: (value) {
                          if (value! > 0) {
                            BlocProvider.of<MapBloc>(context)
                                .add(MapGetCities(value));
                          }
                          setState(() {
                            selectedProvince = value;
                            selectedCity = 0;
                            _cities.clear();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ColoredBox(
                      color: Colors.white,
                      child: DropdownButton(
                        value: selectedCity,
                        items: [
                          const DropdownMenuItem(
                            value: 0,
                            child: Text('انتخاب شهر'),
                          ),
                          for (var c in _cities)
                            DropdownMenuItem(value: c.id, child: Text(c.name))
                        ],
                        onChanged: (value) {
                          if (value! > 0) {
                            var city = _cities
                                .firstWhere((element) => element.id == value);
                            _mapController.move(LatLng(city.lat, city.lng), 12);
                            Timer(const Duration(seconds: 1), () {
                              _fetchPositions();
                            });
                          }
                          setState(() {
                            selectedCity = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  _moveToUserLocation();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.location_searching,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  _addMarker() {
    _markers.clear();

    if (userLocation != null) {
      _markers.add(Marker(key: const ValueKey("self"), point: LatLng(userLocation!.latitude!, userLocation!.longitude!), child: Container(
        decoration: const ShapeDecoration(shape: CircleBorder(), color: Colors.blue),
        height: 18,
        width: 18,
      )));
    }

    for (MapPositionData pos in _positions) {
      _markers.add(
        Marker(
          key: ValueKey(pos.id),
          point: LatLng(pos.lat, pos.lng),
          child: InkWell(
              onTap: () {
                _popupController.togglePopup(_markers[_markers.indexWhere((element) => (element.key as ValueKey).value == pos.id)]);
              },
              child: Container(
                height: 80,
                width: 80,
                child: Image.asset(
                  "assets/img/marker.png",
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              )),
        ),
      );
    }
  }

  Widget _getDialogWidget(Marker marker) {
    int index = _positions.indexWhere((element) => element.id == (marker.key as ValueKey).value);
    var data = _positions[index].getData();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var key in data.keys)
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
              TextSpan(
                  text: '$key: ',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: data[key])
            ]),
          )
      ],
    );
  }

  _fetchPositions() {
    BlocProvider.of<MapBloc>(context).add(MapGetPositions(
        type: type,
        id: id,
        fromLat: _mapController.camera.visibleBounds.southWest.latitude,
        fromLng: _mapController.camera.visibleBounds.southWest.longitude,
        toLat: _mapController.camera.visibleBounds.northEast.latitude,
        toLng: _mapController.camera.visibleBounds.northEast.longitude));
  }

  Future<void> _moveToUserLocation() async {
    if (LocationService.location != null) {
      userLocation = LocationService.location!;
      _mapController.move(
          LatLng(userLocation!.latitude, userLocation!.longitude), 16);
      _addMarker();
      return;
    }

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        _showAlertDialog('سرویس لوکیشن شما غیرفعال است. لطفا آن را فعال کرده و بر روی گزینه موقعیت پایین صفحه بزنید');
        return;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showAlertDialog('اجازه دسترسی به موقعیت به برنامه داده نشد. لطفا مجوز لازم را به برنامه بدهید');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showAlertDialog('اجازه دسترسی به موقعیت برای همیشه از برنامه گرفته شده است لطفا از طریق تنظیمات مجوز لازم را بدهید');
      return;
    }

    userLocation = await Geolocator.getCurrentPosition();

    _mapController.move(
        LatLng(userLocation!.latitude, userLocation!.longitude), 16);
    _addMarker();
  }

  _showAlertDialog(String text) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text(''),
            content: Text(text),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: const Text('متوجه شدم')),
            ],
          ),
        );
      },
    );
  }
}
