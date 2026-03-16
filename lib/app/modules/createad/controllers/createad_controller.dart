import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/category_model.dart';

class CreateadController extends GetxController {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();


  final selectedImages = <XFile>[].obs;
  final selectedCategory = ''.obs;
  final selectedDistrict = ''.obs;
  final selectedTown = ''.obs;
  final selectedProvince = ''.obs;
  final userLocation = ''.obs;
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


  final districts = <String>[
    'Bangalore',
    'Mangalore',
    'Mysore',
    'Udupi',
    'Dakshina Kannada',
    'Other',
  ].obs;


  final townsByDistrict = <String, List<String>>{
    'Bangalore': ['Bangalore City', 'Whitefield', 'Indiranagar', 'Koramangala'],
    'Mangalore': ['Mangalore City', 'Surathkal', 'Bajpe', 'Mulki'],
    'Mysore': ['Mysore City', 'Hebbal', 'Yelahanka', 'Jayalakshmipuram'],
  }.obs;

  final Map<String, Map<String, double>> districtBounds = {
    'Bangalore': {'minLat': 12.8, 'maxLat': 13.2, 'minLng': 77.3, 'maxLng': 77.8},
    'Mangalore': {'minLat': 12.8, 'maxLat': 13.0, 'minLng': 74.8, 'maxLng': 75.0},
    'Mysore': {'minLat': 11.9, 'maxLat': 12.4, 'minLng': 75.5, 'maxLng': 76.2},
    'Udupi': {'minLat': 13.3, 'maxLat': 13.5, 'minLng': 74.7, 'maxLng': 75.0},
    'Dakshina Kannada': {'minLat': 12.6, 'maxLat': 13.2, 'minLng': 74.6, 'maxLng': 75.4},
    'Other': {'minLat': 8.0, 'maxLat': 16.0, 'minLng': 74.0, 'maxLng': 78.0},
  };

  Stream<List<CategoryModel>> getCategories() {
    return FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .map((snapshot) {
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
    for (var entry in districtBounds.entries) {
      String districtName = entry.key;
      Map<String, double> bounds = entry.value;

      if (lat >= bounds['minLat']! &&
          lat <= bounds['maxLat']! &&
          lng >= bounds['minLng']! &&
          lng <= bounds['maxLng']!) {
        selectedDistrict.value = districtName;
        updateTowns(districtName);
        return;
      }
    }

    selectedDistrict.value = 'Other';
    updateTowns('Other');
  }

  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
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
    } catch (e) {
      imageError.value = 'Failed to pick images';
    }
  }


  void removeImage(int index) {
    selectedImages.removeAt(index);
  }


  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    quantityController.clear();
    priceController.clear();
    selectedImages.clear();
    selectedCategory.value = '';
    selectedDistrict.value = '';
    selectedTown.value = '';
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


      Get.snackbar('Success', 'Ad created successfully');
      clearForm();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create ad: $e');
    } finally {
      isLoading.value = false;
    }
  }


  void updateTowns(String district) {
    selectedDistrict.value = district;
    selectedTown.value = '';
  }

  void updateDistrict(String newDistrict) {
    if (!isDistrictAutoDetected.value) {
      selectedDistrict.value = newDistrict;
      updateTowns(newDistrict);
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
