import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleItemController extends GetxController {
  late Map<String, dynamic> ad;
  final currentImageIndex = 0.obs;
  late PageController pageController;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    ad = Get.arguments as Map<String, dynamic>? ?? {};
    pageController = PageController();
    _startImageSlider();
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
