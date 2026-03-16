import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;
  var isFarmerMode = true.obs; // Toggle between Farmer and Buyer mode
  var userRole = 'farmer'.obs; // Total capability (from Firestore)

  @override
  void onInit() {
    super.onInit();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          userRole.value = doc.data()?['accountType'] ?? 'farmer';
          // By default, set mode to their account type
          isFarmerMode.value = userRole.value == 'farmer';
        }
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }
  }

  void toggleRole() {
    isFarmerMode.value = !isFarmerMode.value;
    selectedIndex.value = 0; // Reset to home when switching
  }

  void changePage(int index) {
    selectedIndex.value = index;
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
