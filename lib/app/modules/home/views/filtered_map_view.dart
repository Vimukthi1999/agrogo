import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../routes/app_pages.dart';

class FilteredMapView extends StatefulWidget {
  const FilteredMapView({super.key});

  @override
  State<FilteredMapView> createState() => _FilteredMapViewState();
}

class _FilteredMapViewState extends State<FilteredMapView> {
  final MapController _mapController = MapController();
  List<Map<String, dynamic>> _listings = [];
  bool _isLoading = true;
  Map<String, dynamic>? _selectedListing;

  // Filter args passed from home screen
  late String filterCategory;
  late String filterProvince;
  late String filterDistrict;
  late String searchQuery;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    filterCategory = args['filterCategory'] ?? '';
    filterProvince = args['filterProvince'] ?? '';
    filterDistrict = args['filterDistrict'] ?? '';
    searchQuery = args['searchQuery'] ?? '';
    _fetchFilteredListings();
  }

  void _fetchFilteredListings() {
    FirebaseFirestore.instance
        .collection('listings')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final filtered = <Map<String, dynamic>>[];

      for (final doc in snapshot.docs) {
        final ad = doc.data();
        ad['id'] = doc.id;

        // Apply filters
        if (searchQuery.isNotEmpty) {
          final title = (ad['title'] ?? '').toString().toLowerCase();
          final description =
              (ad['description'] ?? '').toString().toLowerCase();
          final q = searchQuery.toLowerCase();
          if (!title.contains(q) && !description.contains(q)) continue;
        }

        if (filterCategory.isNotEmpty && filterCategory != 'All') {
          if (ad['category'] != filterCategory) continue;
        }

        if (filterProvince.isNotEmpty && filterProvince != 'All') {
          if (ad['province'] != filterProvince) continue;
        }

        if (filterDistrict.isNotEmpty && filterDistrict != 'All') {
          if (ad['district'] != filterDistrict) continue;
        }


        // Must have valid location
        final location = ad['location'];
        if (location == null) continue;
        double? lat, lng;
        if (location is Map) {
          lat = (location['latitude'] as num?)?.toDouble();
          lng = (location['longitude'] as num?)?.toDouble();
        }
        if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) continue;

        filtered.add(ad);
      }

      if (mounted) {
        setState(() {
          _listings = filtered;
          _isLoading = false;
        });
      }
    }, onError: (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint("Error fetching listings for map: $e");
    });
  }

  LatLng _getListingLatLng(Map<String, dynamic> ad) {
    final location = ad['location'];
    if (location is Map) {
      return LatLng(
        (location['latitude'] as num).toDouble(),
        (location['longitude'] as num).toDouble(),
      );
    }
    return const LatLng(7.8731, 80.7718); // Sri Lanka center fallback
  }

  LatLng _getMapCenter() {
    if (_listings.isEmpty) {
      return const LatLng(7.8731, 80.7718); // Sri Lanka center
    }
    // Calculate center of all listing points
    double totalLat = 0;
    double totalLng = 0;
    for (final ad in _listings) {
      final point = _getListingLatLng(ad);
      totalLat += point.latitude;
      totalLng += point.longitude;
    }
    return LatLng(totalLat / _listings.length, totalLng / _listings.length);
  }

  double _getInitialZoom() {
    if (_listings.isEmpty) return 8;
    if (_listings.length == 1) return 14;

    // Calculate bounds to determine zoom
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;
    for (final ad in _listings) {
      final point = _getListingLatLng(ad);
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    if (maxDiff < 0.01) return 14;
    if (maxDiff < 0.05) return 12;
    if (maxDiff < 0.1) return 11;
    if (maxDiff < 0.5) return 9;
    if (maxDiff < 1.0) return 8;
    return 7;
  }

  List<String> _getActiveFilterLabels() {
    final labels = <String>[];
    if (filterProvince.isNotEmpty && filterProvince != 'All') {
      labels.add(filterProvince);
    }
    if (filterDistrict.isNotEmpty && filterDistrict != 'All') {
      labels.add(filterDistrict);
    }
    if (filterCategory.isNotEmpty && filterCategory != 'All') {
      labels.add(filterCategory);
    }
    if (searchQuery.isNotEmpty) {
      labels.add('"$searchQuery"');
    }
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    final filterLabels = _getActiveFilterLabels();

    return Scaffold(
      body: Stack(
        children: [
          // Map
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _getMapCenter(),
                    initialZoom: _getInitialZoom(),
                    onTap: (_, __) {
                      setState(() => _selectedListing = null);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.agrogo.app',
                    ),
                    MarkerLayer(
                      markers: _listings.map((ad) {
                        final point = _getListingLatLng(ad);
                        final isSelected = _selectedListing != null &&
                            _selectedListing!['id'] == ad['id'];
                        return Marker(
                          point: point,
                          width: isSelected ? 50 : 40,
                          height: isSelected ? 50 : 40,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedListing = ad);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1E7044)
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1E7044),
                                  width: isSelected ? 3 : 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.eco_rounded,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1E7044),
                                size: isSelected ? 24 : 20,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header row
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: const Color(0xFF1E7044),
                        ),
                        const Expanded(
                          child: Text(
                            'Listings Map',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E7044),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1E7044).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_listings.length} items',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E7044),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  // Active filter chips
                  if (filterLabels.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: filterLabels.map((label) {
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFF1E7044)
                                      .withValues(alpha: 0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.filter_alt_outlined,
                                    size: 14,
                                    color: Color(0xFF1E7044),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E7044),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom Card (selected listing)
          if (_selectedListing != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: _buildListingCard(_selectedListing!),
            ),

          // Empty state
          if (!_isLoading && _listings.isEmpty)
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_off_outlined,
                      size: 56,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No listings found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your filters to see more results on the map.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1E7044),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> ad) {
    final images = ad['images'] as List<dynamic>?;
    final imageUrl = (images != null && images.isNotEmpty)
        ? images[0]
        : "https://via.placeholder.com/150";

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SINGLE_ITEM, arguments: ad);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: SizedBox(
                width: 110,
                height: 120,
                child: Image.network(
                  imageUrl.toString(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ad['title'] ?? 'Untitled',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E7044),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${ad['district'] ?? ''}, ${ad['province'] ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs. ${ad['price']} / kg',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D9B5F),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E7044),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
