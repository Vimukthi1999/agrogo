import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../nav/controllers/nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/category_model.dart';

class CreateadController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  final selectedImages = <XFile>[].obs;
  final selectedCategory = ''.obs;
  final province = ''.obs;
  final district = ''.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final isLoading = false.obs;
  final isGettingLocation = false.obs;
  final isDistrictAutoDetected = false.obs;

  final titleError = ''.obs;
  final descriptionError = ''.obs;
  final quantityError = ''.obs;
  final priceError = ''.obs;
  final imageError = ''.obs;
  final categoryError = ''.obs;
  final locationError = ''.obs;

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

  final List<String> allDistricts = [
    'Colombo', 'Gampaha', 'Kalutara', 'Kandy', 'Matale', 'Nuwara Eliya',
    'Galle', 'Matara', 'Hambantota', 'Jaffna', 'Kilinochchi', 'Mannar',
    'Vavuniya', 'Mullaitivu', 'Batticaloa', 'Ampara', 'Trincomalee',
    'Kurunegala', 'Puttalam', 'Anuradhapura', 'Polonnaruwa', 'Badulla',
    'Monaragala', 'Ratnapura', 'Kegalle'
  ];

  // More accurate district center coordinates for proximity matching
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



  Stream<List<CategoryModel>> getCategories() {
    return FirebaseFirestore.instance.collection('categories').snapshots().map((
      snapshot,
    ) {
      log('Categories snapshot: ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        log('No categories documents found');
        return [];
      }

      try {
        final categories = snapshot.docs
            .map((doc) {
              try {
                final data = doc.data();
                log('Document ${doc.id} data: $data');

                if (!data.containsKey('name') || !data.containsKey('icon')) {
                  log('Document ${doc.id} missing required fields');
                  return null;
                }

                return CategoryModel.fromMap(doc.id, data);
              } catch (e) {
                log('Error mapping document ${doc.id}: $e');
                return null;
              }
            })
            .whereType<CategoryModel>()
            .toList();

        log('Successfully mapped ${categories.length} categories');
        return categories;
      } catch (e) {
        log('Error in getCategories: $e');
        return [];
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> useSavedLocation() async {
    try {
      isGettingLocation.value = true;
      locationError.value = '';

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        locationError.value = 'User not logged in';
        return false;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey('location')) {
          final loc = data['location'];
          latitude.value = loc['latitude'];
          longitude.value = loc['longitude'];
          district.value = data['district'] ?? '';
          province.value = data['province'] ?? '';

          log('Saved location fetched: ${latitude.value}, ${longitude.value}');

          if (district.isEmpty) {
            _mapLocationToDistrict(latitude.value, longitude.value);
          }

          isDistrictAutoDetected.value = true;
          Get.snackbar('Success', 'Saved location used');
          return true;
        } else {
          locationError.value = 'No saved location found';
        }
      }
      return false;
    } catch (e) {
      locationError.value = 'Failed to fetch saved location';
      log('Saved location error: $e');
      return false;
    } finally {
      isGettingLocation.value = false;
    }
  }

  Future<bool> getCurrentLocation() async {
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
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      log('Current location detected: ${position.latitude}, ${position.longitude}');

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      _mapLocationToDistrict(position.latitude, position.longitude);
      isDistrictAutoDetected.value = true;

      Get.snackbar(
        'Success',
        'Current location detected',
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      locationError.value = 'Failed to get location';
      log('Location error: $e');
      return false;
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
      isDistrictAutoDetected.value = true;
      return true;
    } catch (e) {
      log('Error updating from map: $e');
      return false;
    }
  }

  void _mapLocationToDistrict(double lat, double lng) {
    String closestDistrict = 'Colombo';
    double minDistance = double.infinity;

    // Use a simple proximity matching (nearest center) for higher accuracy than rough bounding boxes
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

  Future<void> pickImages(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      if (source == ImageSource.gallery) {
        final List<XFile> images = await picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 80,
        );

        if (images.isNotEmpty) {
          if (selectedImages.length + images.length <= 5) {
            selectedImages.addAll(images);
            imageError.value = '';
          } else {
            imageError.value = 'Maximum 5 images allowed';
          }
        }
      } else {
        // Camera source
        if (selectedImages.length >= 5) {
          imageError.value = 'Maximum 5 images allowed';
          return;
        }

        final XFile? image = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 80,
        );

        if (image != null) {
          selectedImages.add(image);
          imageError.value = '';
        }
      }
    } catch (e) {
      imageError.value = 'Failed to pick images';
      log('Error picking images: $e');
    }
  }

  Future<void> retakeImage(int index, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImages[index] = image;
      }
    } catch (e) {
      log('Error retaking image: $e');
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    if (selectedImages.isEmpty) {
      imageError.value = 'At least one image is required';
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    quantityController.clear();
    priceController.clear();
    selectedImages.clear();
    selectedCategory.value = '';
    district.value = '';
    province.value = '';
  }

  bool validateForm() {
    clearErrors();
    bool isValid = true;

    if (titleController.text.isEmpty) {
      titleError.value = 'Title is required';
      isValid = false;
    } else if (titleController.text.length < 5) {
      titleError.value = 'Title must be at least 5 characters';
      isValid = false;
    }

    if (descriptionController.text.isEmpty) {
      descriptionError.value = 'Description is required';
      isValid = false;
    } else if (descriptionController.text.length < 10) {
      descriptionError.value = 'Description must be at least 10 characters';
      isValid = false;
    }

    if (quantityController.text.isEmpty) {
      quantityError.value = 'Quantity is required';
      isValid = false;
    } else if (double.tryParse(quantityController.text) == null) {
      quantityError.value = 'Enter a valid quantity';
      isValid = false;
    }

    if (priceController.text.isEmpty) {
      priceError.value = 'Price is required';
      isValid = false;
    } else if (double.tryParse(priceController.text) == null) {
      priceError.value = 'Enter a valid price';
      isValid = false;
    }

    if (selectedImages.isEmpty) {
      imageError.value = 'At least one image is required';
      isValid = false;
    }

    if (selectedCategory.isEmpty) {
      categoryError.value = 'Please select a category';
      isValid = false;
    }

    if (province.isEmpty || district.isEmpty) {
      locationError.value = 'Please detect your location';
      isValid = false;
    }

    return isValid;
  }

  void clearErrors() {
    titleError.value = '';
    descriptionError.value = '';
    quantityError.value = '';
    priceError.value = '';
    imageError.value = '';
    categoryError.value = '';
    locationError.value = '';
  }

  Future<void> createAd() async {
    if (!validateForm()) {
      return;
    }

    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final List<String> imageUrls = [];

      // Upload all selected images to Supabase
      for (var xFile in selectedImages) {
        final fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}_${selectedImages.indexOf(xFile)}.jpg';
        final path = 'product_images/$fileName';
        final file = File(xFile.path);

        await sb.Supabase.instance.client.storage
            .from('images')
            .upload(path, file);

        final downloadUrl = sb.Supabase.instance.client.storage
            .from('images')
            .getPublicUrl(path);
        
        imageUrls.add(downloadUrl);
      }

      log('Uploaded images: $imageUrls');

      // Fetch seller name for better display in listings
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final sellerName = userDoc.data()?['name'] ?? 'Unknown Seller';

      // Add to Firestore collection 'listings'
      await FirebaseFirestore.instance.collection('listings').add({
        'sellerId': user.uid,
        'sellerName': sellerName,
        'title': titleController.text.trim(),
        'titleLower': titleController.text.trim().toLowerCase(), // For search filtering
        'description': descriptionController.text.trim(),
        'quantity': double.parse(quantityController.text),
        'price': double.parse(priceController.text),
        'category': selectedCategory.value,
        'images': imageUrls,
        'location': {
          'latitude': latitude.value,
          'longitude': longitude.value,
        },
        'district': district.value,
        'province': province.value,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active', // Set to active for immediate visibility
      });

      // 1. First, go back to the previous screen (My Ads)
      Get.back();

      // 2. Then, switch the tab to My Ads (Index 1)
      if (Get.isRegistered<NavController>()) {
        Get.find<NavController>().changePage(1);
      }

      // 3. Finally, show the success message on the landing screen
      Get.snackbar(
        'Success',
        'Ad created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create ad: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateDistrict(String newDistrict) {
    if (!isDistrictAutoDetected.value) {
      district.value = newDistrict;
      province.value = districtToProvince[newDistrict] ?? '';
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
