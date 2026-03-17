import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class MyadsController extends GetxController {
  final userAds = <DocumentSnapshot>[].obs;
  final isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription? _adsSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchUserAds();
  }

  void fetchUserAds() {
    final user = _auth.currentUser;
    if (user == null) return;

    isLoading.value = true;
    _adsSubscription?.cancel();
    
    _adsSubscription = _firestore
        .collection('listings')
        .where('sellerId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      userAds.assignAll(snapshot.docs);
      isLoading.value = false;
    }, onError: (error) {
      debugPrint("Error fetching ads: $error");
      isLoading.value = false;
    });
  }

  void editAd(DocumentSnapshot doc) {
    Get.toNamed(
      Routes.CREATEAD,
      arguments: {
        'isEditing': true,
        'adId': doc.id,
        'adData': doc.data(),
      },
    );
  }

  void deleteAd(String adId) {
    Get.defaultDialog(
      title: 'Delete Ad',
      middleText: 'Are you sure you want to delete this ad?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        try {
          Get.back(); // Close dialog
          await _firestore.collection('listings').doc(adId).delete();
          Get.snackbar('Success', 'Ad deleted successfully');
        } catch (e) {
          Get.snackbar('Error', 'Failed to delete ad: $e');
        }
      },
    );
  }

  Future<void> toggleAdStatus(String adId, String currentStatus) async {
    final status = currentStatus.toLowerCase();
    final newStatus = status == 'active' ? 'inactive' : 'active';
    
    try {
      await _firestore.collection('listings').doc(adId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Use a slight delay to ensure snackbar shows up clearly
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'Success',
          'Listing is now ${newStatus.toUpperCase()}',
          snackPosition: SnackPosition.TOP, // Top is often safer than Bottom with NavBars
          backgroundColor: newStatus == 'active' ? Colors.green : Colors.grey[700],
          colorText: Colors.white,
          icon: Icon(
            newStatus == 'active' ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 2),
        );
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _adsSubscription?.cancel();
    super.onClose();
  }
}
