import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap(
      {this.markers,
      this.listOfMarker,
      this.circles,
      this.zoom,
      this.zoomGesturesEnabled,
      this.position,
      this.destination,
      this.polyLines,
      this.onMapCreated,
      this.myLocationEnabled = true});
  final Set<Marker> markers;
  final List<Map<String, dynamic>> listOfMarker;
  final Set<Circle> circles;
  final double zoom;
  final bool zoomGesturesEnabled;
  final Position position;
  final LatLng destination;
  final Set<Polyline> polyLines;
  final Function(GoogleMapController) onMapCreated;
  final bool myLocationEnabled;
  @override
  _CustomGoogleMapState createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap>
    with WidgetsBindingObserver {
  String mapStyle;
  String mapStyleDark;
  GoogleMapController mapController;
  Completer<GoogleMapController> completer = Completer();
  bool darkMode = false;

  void onMapCreated(GoogleMapController controller, {bool darkmode}) {
    mapController = controller;
    if (darkMode) {
      mapController.setMapStyle(mapStyle);
    } else {
      mapController.setMapStyle(mapStyleDark);
    }
    if (!completer.isCompleted) {
      completer.complete(controller);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    DefaultAssetBundle.of(context)
        .loadString('images/style_map/style_map.json')
        .then((string) {
      mapStyle = string;
    });
    DefaultAssetBundle.of(context)
        .loadString('images/style_map/style_map_dark.json')
        .then((string) {
      mapStyleDark = string;
    });
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        final GoogleMapController controller = await completer.future;
        onMapCreated(controller, darkmode: darkMode);
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    darkMode = Theme.of(context).brightness == Brightness.light;
    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      myLocationEnabled: widget.myLocationEnabled,
      mapToolbarEnabled: false,
      polylines: widget.polyLines,
      zoomGesturesEnabled: widget.zoomGesturesEnabled ?? true,
      circles: widget.circles,
      onMapCreated: widget.onMapCreated ??
          (controller) {
            onMapCreated(controller, darkmode: darkMode);
          },
      initialCameraPosition: CameraPosition(
          target: widget.position != null
              ? LatLng(widget.position.latitude, widget.position.longitude)
              : widget.destination,
          zoom: widget.zoom ?? 13),
    );
  }
}
