import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final loadingUpdateMe = false.obs;
  final loadingUpdatePw = false.obs;

  final currentPwController = TextEditingController();
  final newPwController = TextEditingController();
  final confirmPwController = TextEditingController();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final userName = ''.obs;
  final userEmail = ''.obs;
  final profileImage = ''.obs;

  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data()!;
          userName.value = data['name'] ?? '';
          userEmail.value = data['email'] ?? '';
          profileImage.value = data['profileImage'] ?? '';
          
          nameController.text = userName.value;
          emailController.text = userEmail.value;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data');
    }
  }

  Future<void> updateAboutMe() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty');
      return;
    }
    
    try {
      loadingUpdateMe.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': nameController.text.trim(),
        });
        userName.value = nameController.text.trim();
        Get.snackbar('Success', 'Profile updated successfully');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      loadingUpdateMe.value = false;
    }
  }

  Future<void> updatePw() async {
    if (currentPwController.text.isEmpty || 
        newPwController.text.isEmpty || 
        confirmPwController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    if (newPwController.text != confirmPwController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    try {
      loadingUpdatePw.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        // Re-authenticate user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPwController.text,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPwController.text);
        
        Get.snackbar('Success', 'Password updated successfully');
        currentPwController.clear();
        newPwController.clear();
        confirmPwController.clear();
        Get.back();
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Failed to update password');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      loadingUpdatePw.value = false;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/splash');
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
