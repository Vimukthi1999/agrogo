import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/createad_controller.dart';

class LocationPickerView extends StatefulWidget {
  const LocationPickerView({super.key});

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  final controller = Get.find<CreateadController>();
  LatLng? _pickedLocation;
  
  @override
  void initState() {
    super.initState();
    // Default to Colombo or current detected location
    if (controller.latitude.value != 0.0) {
      _pickedLocation = LatLng(controller.latitude.value, controller.longitude.value);
    } else {
      _pickedLocation = const LatLng(6.9271, 79.8612); // Colombo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'.tr),
        backgroundColor: const Color(0xFF1E7044),
        actions: [
          if (_pickedLocation != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                controller.updateFromMap(_pickedLocation!);
                Get.back();
              },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pickedLocation!,
          zoom: 13,
        ),
        onMapCreated: (mapController) {},
        onTap: (latLng) {
          setState(() {
            _pickedLocation = latLng;
          });
        },
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('picked'),
                  position: _pickedLocation!,
                ),
              },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1E7044),
        onPressed: _pickedLocation == null
            ? null
            : () {
                controller.updateFromMap(_pickedLocation!);
                Get.back();
              },
        label: Text('Confirm Location'.tr),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}
