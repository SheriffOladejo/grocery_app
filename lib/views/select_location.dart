import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocation extends StatefulWidget {

  double lat;
  double lng;

  SelectLocation({this.lat, this.lng});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {

  String key = "AIzaSyDrPUEhjSLscb-Vm59Pez6D9FgaJIMe9Uw";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: PlacePicker(
            apiKey: Platform.isAndroid
                ? key
                : "YOUR IOS API KEY",
            onPlacePicked: (result) {
              var address = "${result.name}, ${result.formattedAddress}";
              Navigator.of(context).pop(address);
            },
            initialPosition: LatLng(widget.lat, widget.lng),
            useCurrentLocation: true,
            resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
          )),
    );
  }
}

