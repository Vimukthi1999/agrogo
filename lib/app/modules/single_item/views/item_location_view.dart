import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemLocationView extends StatelessWidget {
  final Map<String, dynamic> ad;
  
  const ItemLocationView({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final location = ad['location'];
    
    double lat = 6.9271;
    double lng = 79.8612;

    if (location is Map) {
      lat = (location['latitude'] as num?)?.toDouble() ?? lat;
      lng = (location['longitude'] as num?)?.toDouble() ?? lng;
    } else {
      // Handle GeoPoint or other objects with latitude/longitude properties if possible.
      // Easiest is to try a dynamic cast since cloud_firestore is not imported here.
      try {
        final dynamic dynLoc = location;
        if (dynLoc != null) {
          lat = (dynLoc.latitude as num?)?.toDouble() ?? lat;
          lng = (dynLoc.longitude as num?)?.toDouble() ?? lng;
        }
      } catch (_) {
        debugPrint("Location parsing error for dynamic type.");
      }
    }

    final LatLng itemPoint = LatLng(lat, lng);

    return Scaffold(
      appBar: AppBar(
        title: Text(ad['title'] ?? 'Item Location'),
        backgroundColor: const Color(0xFF1E7044),
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: itemPoint,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.agrogo.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: itemPoint,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFF1E7044),
                  size: 45,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openInExternalMap(lat, lng),
        backgroundColor: const Color(0xFF1E7044),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.directions),
        label: const Text("Get Directions"),
      ),
    );
  }

  void _openInExternalMap(double lat, double lng) async {
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    final Uri uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
