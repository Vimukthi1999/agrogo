import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../views/item_location_view.dart';

class SingleItemController extends GetxController {
  late Map<String, dynamic> ad;
  final currentImageIndex = 0.obs;
  final sellerPhone = "".obs;
  final sellerData = Rx<Map<String, dynamic>?>(null);
  final sellerListingsCount = 0.obs;
  late PageController pageController;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    ad = Get.arguments as Map<String, dynamic>? ?? {};
    pageController = PageController();
    _startImageSlider();
    _fetchSellerData();
  }

  Future<void> _fetchSellerData() async {
    final sellerId = ad['sellerId'];
    if (sellerId != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(sellerId)
            .get();
        if (doc.exists) {
          final data = doc.data() ?? {};
          data['uid'] = sellerId;
          sellerData.value = data;
          sellerPhone.value = data['phone'] ?? "";
        }

        // Fetch seller's active listings count
        final listingsSnapshot = await FirebaseFirestore.instance
            .collection('listings')
            .where('sellerId', isEqualTo: sellerId)
            .where('status', isEqualTo: 'active')
            .get();
        sellerListingsCount.value = listingsSnapshot.docs.length;
      } catch (e) {
        debugPrint("Error fetching seller data: $e");
      }
    }
  }

  void _startImageSlider() {
    final images = ad['images'] as List<dynamic>? ?? [];
    if (images.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients) {
        int nextIndex = (currentImageIndex.value + 1) % images.length;
        pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }

  Future<void> makePhoneCall() async {
    if (sellerPhone.value.isNotEmpty) {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: sellerPhone.value,
      );
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        Get.snackbar("Error", "Could not initiate phone call.");
      }
    } else {
      Get.snackbar("Notice", "Seller phone number not available.");
    }
  }

  void openLocationInMap() {
    debugPrint("DEBUG: Opening map for item: ${ad['title']}");
    final location = ad['location'];
    
    double? lat;
    double? lng;

    if (location is Map) {
      lat = (location['latitude'] as num?)?.toDouble();
      lng = (location['longitude'] as num?)?.toDouble();
    } else if (location is GeoPoint) {
      lat = location.latitude;
      lng = location.longitude;
    }

    debugPrint("DEBUG: Coordinates: $lat, $lng");

    if (lat != null && lng != null) {
      Get.to(() => ItemLocationView(ad: ad));
    } else {
      debugPrint("DEBUG: Missing location data");
      Get.snackbar(
        "Notice", 
        "No location data available for this listing.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
