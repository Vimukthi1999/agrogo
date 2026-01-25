import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SigninController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if user is already signed in
    firebaseUser.bindStream(auth.authStateChanges());
    
    // Listen to auth state changes and navigate if user is signed in
    ever<User?>(firebaseUser, (User? user) {
      if (user != null) {
        Get.offAllNamed(Routes.NAV);
      }
    });
  }

  // Login
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty");
      return;
    }

    try {
      isLoading.value = true;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "User not found. Please register first.");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Wrong password. Please try again.");
      } else {
        Get.snackbar("Error", e.message ?? "Login failed");
      }
      log(e.toString());
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "An unexpected error occurred");
      log(e.toString());
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
