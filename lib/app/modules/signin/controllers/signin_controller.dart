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
  RxBool isPasswordVisible = false.obs;

  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();

    firebaseUser.bindStream(auth.authStateChanges());

    ever<User?>(firebaseUser, (User? user) {
      if (user != null) {
        Get.offAllNamed(Routes.NAV);
      }
    });
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }

  bool validateInputs(String email, String password) {
    clearErrors();
    bool isValid = true;

    if (email.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!isValidEmail(email)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    return isValid;
  }

  Future<void> login(String email, String password) async {
    if (!validateInputs(email, password)) {
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
