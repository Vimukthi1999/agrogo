import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isGettingLocation = false.obs;

  
  RxString accountType = 'farmer'.obs;
  RxString province = ''.obs;
  RxString district = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;


  RxString nameError = ''.obs;
  RxString emailError = ''.obs;
  RxString phoneError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;
  RxString locationError = ''.obs;


  final Map<String, String> districtToProvince = {
    'Colombo': 'Western',
    'Gampaha': 'Western',
    'Kalutara': 'Western',
    'Matara': 'Southern',
    'Galle': 'Southern',
    'Hambantota': 'Southern',
    'Kandy': 'Central',
    'Matale': 'Central',
    'Nuwara Eliya': 'Central',
    'Jaffna': 'Northern',
    'Mullaitivu': 'Northern',
    'Batticaloa': 'Eastern',
    'Ampara': 'Eastern',
    'Trincomalee': 'Eastern',
    'Kurunegala': 'North Western',
    'Puttalam': 'North Western',
    'Anuradhapura': 'North Central',
    'Polonnaruwa': 'North Central',
    'Badulla': 'Uva',
    'Monaragala': 'Uva',
    'Ratnapura': 'Sabaragamuwa',
    'Kegalle': 'Sabaragamuwa',
  };

  final List<String> allDistricts = [
    'Colombo', 'Gampaha', 'Kalutara', 'Matara', 'Galle', 'Hambantota',
    'Kandy', 'Matale', 'Nuwara Eliya', 'Jaffna', 'Mullaitivu',
    'Batticaloa', 'Ampara', 'Trincomalee', 'Kurunegala', 'Puttalam',
    'Anuradhapura', 'Polonnaruwa', 'Badulla', 'Monaragala', 'Ratnapura', 'Kegalle',
  ];

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
    
  
    ever<User?>(firebaseUser, (User? user) {
      if (user != null) {
        Get.offAllNamed(Routes.HOME);
      }
    });
  }


  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }


  String getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Weak';
    if (password.length < 8) return 'Fair';
    if (RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])').hasMatch(password)) {
      return 'Strong';
    }
    return 'Good';
  }

 
  void clearErrors() {
    nameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    locationError.value = '';
  }

 
  bool validateInputs(String name, String email, String phone, String password, String confirmPassword) {
    clearErrors();
    bool isValid = true;

    if (name.isEmpty) {
      nameError.value = 'Full name is required';
      isValid = false;
    } else if (name.length < 3) {
      nameError.value = 'Name must be at least 3 characters';
      isValid = false;
    }

    if (email.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!isValidEmail(email)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    if (phone.isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (phone.length < 10) {
      phoneError.value = 'Please enter a valid phone number';
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

  Future<void> getCurrentLocation() async {
    try {
      isGettingLocation.value = true;
      locationError.value = '';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Location permission is required';
        isGettingLocation.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      _mapLocationToDistrict(position.latitude, position.longitude);

      Get.snackbar('Success', 'Location detected successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      locationError.value = 'Failed to get location';
      log('Location error: $e');
    } finally {
      isGettingLocation.value = false;
    }
  }

  void _mapLocationToDistrict(double lat, double lng) {
    if (lat >= 5.8 && lat <= 6.8 && lng >= 80.2 && lng <= 80.8) {
      district.value = 'Matara';
      province.value = districtToProvince['Matara'] ?? '';
    } else if (lat >= 6.7 && lat <= 7.1 && lng >= 79.7 && lng <= 80.0) {
      district.value = 'Colombo';
      province.value = districtToProvince['Colombo'] ?? '';
    } else if (lat >= 6.8 && lat <= 7.4 && lng >= 80.4 && lng <= 81.0) {
      district.value = 'Kandy';
      province.value = districtToProvince['Kandy'] ?? '';
    } else {
      district.value = 'Colombo';
      province.value = 'Western';
    }
  }

  void updateDistrict(String newDistrict) {
    district.value = newDistrict;
    province.value = districtToProvince[newDistrict] ?? '';
  }


  Future<void> register(String name, String email, String phone, String password,
      String confirmPassword) async {
    if (!validateInputs(name, email, phone, password, confirmPassword)) {
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
        'name': name,
        'email': email,
        'phone': phone,
        'role': accountType.value,
        'accountType': accountType.value,
        'district': district.value,
        'province': province.value,
        'location': {
          'latitude': latitude.value,
          'longitude': longitude.value,
        },
        'createdAt': FieldValue.serverTimestamp(),
        'profileComplete': false,
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
