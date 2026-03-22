import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../../../services/theme_service.dart';

class SettingsController extends GetxController {
  final _themeService = ThemeService();
  final isDarkMode = false.obs;

  void onInit() {
    super.onInit();
    fetchUserData();
    isDarkMode.value = _themeService.theme == ThemeMode.dark;
  }

  void switchTheme() {
    _themeService.switchTheme();
    isDarkMode.value = !isDarkMode.value;
  }
  final loadingUpdateMe = false.obs;
  final loadingUpdatePw = false.obs;

  final currentPwController = TextEditingController();
  final newPwController = TextEditingController();
  final confirmPwController = TextEditingController();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final profileImage = ''.obs;
  final accountType = ''.obs;
  
  final province = ''.obs;
  final district = ''.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final isGettingLocation = false.obs;
  final selectedProfileImage = Rxn<File>();

  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  final Map<String, String> districtToProvince = {
    'Colombo': 'Western',
    'Gampaha': 'Western',
    'Kalutara': 'Western',
    'Kandy': 'Central',
    'Matale': 'Central',
    'Nuwara Eliya': 'Central',
    'Galle': 'Southern',
    'Matara': 'Southern',
    'Hambantota': 'Southern',
    'Jaffna': 'Northern',
    'Kilinochchi': 'Northern',
    'Mannar': 'Northern',
    'Vavuniya': 'Northern',
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

  final Map<String, LatLng> districtCenters = {
    'Colombo': LatLng(6.9271, 79.8612),
    'Gampaha': LatLng(7.0840, 80.0098),
    'Kalutara': LatLng(6.5854, 79.9607),
    'Kandy': LatLng(7.2906, 80.6337),
    'Matale': LatLng(7.4675, 80.6234),
    'Nuwara Eliya': LatLng(6.9497, 80.7891),
    'Galle': LatLng(6.0367, 80.2170),
    'Matara': LatLng(5.9549, 80.5550),
    'Hambantota': LatLng(6.1245, 81.1185),
    'Jaffna': LatLng(9.6615, 80.0255),
    'Kilinochchi': LatLng(9.3803, 80.3847),
    'Mannar': LatLng(8.9810, 79.9044),
    'Vavuniya': LatLng(8.7542, 80.4982),
    'Mullaitivu': LatLng(9.2671, 80.8143),
    'Batticaloa': LatLng(7.7102, 81.6924),
    'Ampara': LatLng(7.2840, 81.6740),
    'Trincomalee': LatLng(8.5873, 81.2152),
    'Kurunegala': LatLng(7.4863, 80.3647),
    'Puttalam': LatLng(8.0330, 79.8300),
    'Anuradhapura': LatLng(8.3114, 80.4037),
    'Polonnaruwa': LatLng(7.9403, 81.0188),
    'Badulla': LatLng(6.9934, 81.0550),
    'Monaragala': LatLng(6.8710, 81.3530),
    'Ratnapura': LatLng(6.6828, 80.3992),
    'Kegalle': LatLng(7.2513, 80.3464),
  };

  // Removed onInit from here as it was added at the top

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
          userPhone.value = data['phone'] ?? '';
          profileImage.value = data['profileImage'] ?? '';
          accountType.value = data['accountType'] ?? '';
          
          district.value = data['district'] ?? '';
          province.value = data['province'] ?? '';
          
          if (data['location'] != null) {
            latitude.value = data['location']['latitude'] ?? 0.0;
            longitude.value = data['location']['longitude'] ?? 0.0;
          }
          
          nameController.text = userName.value;
          emailController.text = userEmail.value;
          phoneController.text = userPhone.value;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isGettingLocation.value = true;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permission is required');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      _mapLocationToDistrict(position.latitude, position.longitude);
      Get.snackbar('Success', 'Location detected');
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location');
    } finally {
      isGettingLocation.value = false;
    }
  }

  bool updateFromMap(LatLng pickedLocation) {
    try {
      log('Updating from map: ${pickedLocation.latitude}, ${pickedLocation.longitude}');
      latitude.value = pickedLocation.latitude;
      longitude.value = pickedLocation.longitude;
      _mapLocationToDistrict(latitude.value, longitude.value);
      return true;
    } catch (e) {
      log('Error updating from map: $e');
      return false;
    }
  }

  void _mapLocationToDistrict(double lat, double lng) {
    String closestDistrict = 'Colombo';
    double minDistance = double.infinity;

    for (var entry in districtCenters.entries) {
      double dist = Geolocator.distanceBetween(
        lat,
        lng,
        entry.value.latitude,
        entry.value.longitude,
      );

      if (dist < minDistance) {
        minDistance = dist;
        closestDistrict = entry.key;
      }
    }

    district.value = closestDistrict;
    province.value = districtToProvince[closestDistrict] ?? '';
    log('Location mapped to: $closestDistrict, ${province.value} (Distance: ${minDistance / 1000}km)');
  }

  Future<void> pickProfilePicture(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        selectedProfileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> updateAboutMe() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty');
      return;
    }

    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Phone number cannot be empty');
      return;
    }
    
    try {
      loadingUpdateMe.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? downloadUrl;
        
        // Upload image to Supabase if selected
        if (selectedProfileImage.value != null) {
          final fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final path = 'profile_pictures/$fileName';
          
          await sb.Supabase.instance.client.storage
              .from('images')
              .upload(path, selectedProfileImage.value!);

          downloadUrl = sb.Supabase.instance.client.storage
              .from('images')
              .getPublicUrl(path);
          
          profileImage.value = downloadUrl;
        }

        final updateData = {
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'location': {
            'latitude': latitude.value,
            'longitude': longitude.value,
          },
          'district': district.value,
          'province': province.value,
        };

        if (downloadUrl != null) {
          updateData['profileImage'] = downloadUrl;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updateData);
        
        userName.value = nameController.text.trim();
        userPhone.value = phoneController.text.trim();
        selectedProfileImage.value = null; // Clear local selection after success
        
        Get.snackbar('Success', 'Profile updated successfully');
        Get.back();
      }
    } catch (e) {
      log('Update profile error: $e');
      Get.snackbar('Error', 'Failed to update profile: $e');
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
