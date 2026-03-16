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
  RxBool isDistrictAutoDetected = false.obs;


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

  final Map<String, Map<String, double>> districtBounds = {
    'Colombo': {'minLat': 6.7, 'maxLat': 7.0, 'minLng': 79.8, 'maxLng': 80.2},
    'Gampaha': {'minLat': 6.9, 'maxLat': 7.3, 'minLng': 80.0, 'maxLng': 80.4},
    'Kalutara': {'minLat': 6.4, 'maxLat': 6.8, 'minLng': 80.1, 'maxLng': 80.5},
    'Matara': {'minLat': 5.8, 'maxLat': 6.3, 'minLng': 80.5, 'maxLng': 81.0},
    'Galle': {'minLat': 6.0, 'maxLat': 6.5, 'minLng': 80.1, 'maxLng': 80.6},
    'Hambantota': {'minLat': 6.0, 'maxLat': 6.5, 'minLng': 80.7, 'maxLng': 81.5},
    'Kandy': {'minLat': 6.8, 'maxLat': 7.3, 'minLng': 80.4, 'maxLng': 81.0},
    'Matale': {'minLat': 7.3, 'maxLat': 7.7, 'minLng': 80.6, 'maxLng': 81.2},
    'Nuwara Eliya': {'minLat': 6.8, 'maxLat': 7.2, 'minLng': 80.8, 'maxLng': 81.3},
    'Jaffna': {'minLat': 9.5, 'maxLat': 9.8, 'minLng': 80.0, 'maxLng': 80.4},
    'Mullaitivu': {'minLat': 8.5, 'maxLat': 9.0, 'minLng': 81.3, 'maxLng': 81.9},
    'Batticaloa': {'minLat': 7.5, 'maxLat': 8.2, 'minLng': 81.5, 'maxLng': 81.9},
    'Ampara': {'minLat': 7.0, 'maxLat': 7.8, 'minLng': 81.5, 'maxLng': 82.0},
    'Trincomalee': {'minLat': 8.3, 'maxLat': 9.0, 'minLng': 81.1, 'maxLng': 81.7},
    'Kurunegala': {'minLat': 6.8, 'maxLat': 7.5, 'minLng': 80.2, 'maxLng': 80.7},
    'Puttalam': {'minLat': 7.6, 'maxLat': 8.3, 'minLng': 79.7, 'maxLng': 80.2},
    'Anuradhapura': {'minLat': 7.9, 'maxLat': 8.7, 'minLng': 80.3, 'maxLng': 80.9},
    'Polonnaruwa': {'minLat': 7.9, 'maxLat': 8.4, 'minLng': 81.0, 'maxLng': 81.6},
    'Badulla': {'minLat': 6.9, 'maxLat': 7.4, 'minLng': 81.0, 'maxLng': 81.6},
    'Monaragala': {'minLat': 6.6, 'maxLat': 7.2, 'minLng': 81.2, 'maxLng': 81.8},
    'Ratnapura': {'minLat': 6.6, 'maxLat': 7.1, 'minLng': 80.4, 'maxLng': 80.9},
    'Kegalle': {'minLat': 7.1, 'maxLat': 7.6, 'minLng': 80.4, 'maxLng': 80.9},
  };

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

    if (province.isEmpty || district.isEmpty) {
      locationError.value = 'Please detect your location';
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
      isDistrictAutoDetected.value = true;

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
    // Search through all districts to find matching boundaries
    for (var entry in districtBounds.entries) {
      String districtName = entry.key;
      Map<String, double> bounds = entry.value;

      if (lat >= bounds['minLat']! &&
          lat <= bounds['maxLat']! &&
          lng >= bounds['minLng']! &&
          lng <= bounds['maxLng']!) {
        district.value = districtName;
        province.value = districtToProvince[districtName] ?? '';
        return;
      }
    }

    // Default to Colombo if no district is found
    district.value = 'Colombo';
    province.value = 'Western';
  }

  void updateDistrict(String newDistrict) {
    if (!isDistrictAutoDetected.value) {
      district.value = newDistrict;
      province.value = districtToProvince[newDistrict] ?? '';
    }
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
