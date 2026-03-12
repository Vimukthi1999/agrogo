import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyadsController extends GetxController {
  final userAds = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserAds();
  }

  void fetchUserAds() {
    isLoading.value = true;
    try {
     
      userAds.value = [];
      
     
    } finally {
      isLoading.value = false;
    }
  }

  
  void createNewAd() {
    // Get.toNamed(Routes.CREATE_AD);
  }


  void editAd(String adId) {
    // Get.toNamed(Routes.EDIT_AD, arguments: {'adId': adId});
  }

 
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
