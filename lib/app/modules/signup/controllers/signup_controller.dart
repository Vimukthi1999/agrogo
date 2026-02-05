import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  // Validation error states
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
    
    // Listen to auth state changes and navigate if user is signed in
    ever<User?>(firebaseUser, (User? user) {
      if (user != null) {
        Get.offAllNamed(Routes.HOME);
      }
    });
  }

  // Email validation
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Password strength check
  String getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Weak';
    if (password.length < 8) return 'Fair';
    if (RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])').hasMatch(password)) {
      return 'Strong';
    }
    return 'Good';
  }

  // Clear error messages
  void clearErrors() {
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
  }

  // Validate inputs before registration
  bool validateInputs(String email, String password, String confirmPassword) {
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

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      isValid = false;
    } else if (password != confirmPassword) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    }

    return isValid;
  }

  // Register
  Future<void> register(String email, String password, String confirmPassword) async {
    if (!validateInputs(email, password, confirmPassword)) {
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;


    await firestore.collection('users').doc(userId).set({
      'name': 'Geshan Silva',
      'role': 'farmer',
      'phone': '+94XXXXXXXX',
      'email': email,
      'district': 'Matara',
      'province': 'Southern',
      'location': {
        'latitude': 6.9271,
        'longitude': 79.8612,
      },
      'createdAt': FieldValue.serverTimestamp(),
    });

      isLoading.value = false;
      Get.snackbar("Success", "Account created successfully!");
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", "Email is already registered");
      } else if (e.code == 'weak-password') {
        Get.snackbar("Error", "Password is too weak");
      } else {
        Get.snackbar("Error", e.message ?? "Registration failed");
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
    confirmPasswordController.dispose();
    super.onClose();
  }
}
