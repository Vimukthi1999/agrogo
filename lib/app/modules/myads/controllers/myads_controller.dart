import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyadsController extends GetxController {
  final userAds = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch user's ads from Firebase or your backend
    fetchUserAds();
  }

  // Fetch user ads from Firebase
  void fetchUserAds() {
    isLoading.value = true;
    try {
      // TODO: Fetch from Firestore
      // For now, showing empty list
      userAds.value = [];
      
      // Sample data for testing
      // userAds.value = [
      //   {
      //     'id': '1',
      //     'title': 'Premium Organic Seeds',
      //     'category': 'Seeds',
      //     'price': '₹500',
      //     'status': 'Active',
      //     'image': 'https://via.placeholder.com/150',
      //     'date': '2025-01-25',
      //   },
      //   {
      //     'id': '2',
      //     'title': 'Fertilizer Pack',
      //     'category': 'Fertilizers',
      //     'price': '₹1,200',
      //     'status': 'Sold',
      //     'image': 'https://via.placeholder.com/150',
      //     'date': '2025-01-24',
      //   },
      // ];
    } finally {
      isLoading.value = false;
    }
  }

  // Create new ad
  void createNewAd() {
    // Get.toNamed(Routes.CREATE_AD);
  }

  // Edit ad
  void editAd(String adId) {
    // Get.toNamed(Routes.EDIT_AD, arguments: {'adId': adId});
  }

  // Delete ad
  void deleteAd(String adId) {
    Get.defaultDialog(
      title: 'Delete Ad',
      middleText: 'Are you sure you want to delete this ad?',
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Delete from Firestore
            // userAds.removeWhere((ad) => ad['id'] == adId);
            Get.back();
            Get.snackbar('Success', 'Ad deleted successfully');
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
