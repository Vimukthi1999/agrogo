import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/createad_controller.dart';

class LocationPickerView extends StatefulWidget {
  const LocationPickerView({super.key});

  @override
  State<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends State<LocationPickerView> {
  final controller = Get.find<CreateadController>();
  LatLng? _pickedLocation;
  final MapController _mapController = MapController();
  
  @override
  void initState() {
    super.initState();
    // Default to Colombo or current detected location
    if (controller.latitude.value != 0.0 && controller.longitude.value != 0.0) {
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
                print('DEBUG: Top icon confirmation pressed');
                controller.updateFromMap(_pickedLocation!);
                Get.back(); // Returns to Create Ad screen
              },
            ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _pickedLocation!,
          initialZoom: 13,
          onTap: (tapPosition, point) {
            setState(() {
              _pickedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.agrogo.app',
          ),
          if (_pickedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _pickedLocation!,
                  width: 80,
                  height: 80,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1E7044),
        onPressed: _pickedLocation == null
            ? null
            : () {
                print('DEBUG: FAB confirmation pressed');
                controller.updateFromMap(_pickedLocation!);
                Get.back(); // Returns to Create Ad screen
              },
        label: Text('Confirm Location'.tr),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}
