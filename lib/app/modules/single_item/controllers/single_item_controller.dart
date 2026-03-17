import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleItemController extends GetxController {
  late Map<String, dynamic> ad;
  final currentImageIndex = 0.obs;
  final sellerPhone = "".obs;
  late PageController pageController;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    ad = Get.arguments as Map<String, dynamic>? ?? {};
    pageController = PageController();
    _startImageSlider();
    _fetchSellerPhone();
  }

  Future<void> _fetchSellerPhone() async {
    final sellerId = ad['sellerId'];
    if (sellerId != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(sellerId).get();
        if (doc.exists) {
          sellerPhone.value = doc.data()?['phone'] ?? "";
        }
      } catch (e) {
        debugPrint("Error fetching seller phone: $e");
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

  Future<void> openLocationInMap() async {
    final location = ad['location'] as Map<String, dynamic>?;
    final double? lat = location?['latitude'] as double?;
    final double? lng = location?['longitude'] as double?;

    if (lat != null && lng != null) {
      final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
      final Uri uri = Uri.parse(googleMapsUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not open map.");
      }
    } else {
      Get.snackbar("Notice", "No location data available for this listing.");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
