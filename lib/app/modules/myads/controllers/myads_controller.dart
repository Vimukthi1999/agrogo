import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class MyadsController extends GetxController {
  final userAds = <DocumentSnapshot>[].obs;
  final isLoading = false.obs;
  final selectedStatus = 'All'.obs;

  List<DocumentSnapshot> get filteredAds {
    if (selectedStatus.value == 'All') {
      return userAds;
    }
    return userAds.where((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      final status = data?['status'] ?? 'active';
      return status.toString().toLowerCase() == selectedStatus.value.toLowerCase();
    }).toList();
  }

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
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_outline, color: Colors.red[400], size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                'Delete Listing?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E7044),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to remove this ad? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF1E7044)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF1E7044),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          Get.back(); // Close dialog
                          await _firestore.collection('listings').doc(adId).delete();
                          Get.snackbar(
                            'Deleted',
                            'Listing removed successfully',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red[400],
                            colorText: Colors.white,
                          );
                        } catch (e) {
                          Get.snackbar('Error', 'Failed to delete ad: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.red[400],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
