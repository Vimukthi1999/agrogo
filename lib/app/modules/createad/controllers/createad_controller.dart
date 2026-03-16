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
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Matara',
    'Galle',
    'Hambantota',
    'Kandy',
    'Matale',
    'Nuwara Eliya',
    'Jaffna',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Kurunegala',
    'Puttalam',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Monaragala',
    'Ratnapura',
    'Kegalle',
  ];

  final Map<String, Map<String, double>> districtBounds = {
    'Colombo': {'minLat': 6.7, 'maxLat': 7.0, 'minLng': 79.8, 'maxLng': 80.2},
    'Gampaha': {'minLat': 6.9, 'maxLat': 7.3, 'minLng': 80.0, 'maxLng': 80.4},
    'Kalutara': {'minLat': 6.4, 'maxLat': 6.8, 'minLng': 80.1, 'maxLng': 80.5},
    'Matara': {'minLat': 5.8, 'maxLat': 6.3, 'minLng': 80.5, 'maxLng': 81.0},
    'Galle': {'minLat': 6.0, 'maxLat': 6.5, 'minLng': 80.1, 'maxLng': 80.6},
    'Hambantota': {
      'minLat': 6.0,
      'maxLat': 6.5,
      'minLng': 80.7,
      'maxLng': 81.5,
    },
    'Kandy': {'minLat': 6.8, 'maxLat': 7.3, 'minLng': 80.4, 'maxLng': 81.0},
    'Matale': {'minLat': 7.3, 'maxLat': 7.7, 'minLng': 80.6, 'maxLng': 81.2},
    'Nuwara Eliya': {
      'minLat': 6.8,
      'maxLat': 7.2,
      'minLng': 80.8,
      'maxLng': 81.3,
    },
    'Jaffna': {'minLat': 9.5, 'maxLat': 9.8, 'minLng': 80.0, 'maxLng': 80.4},
    'Mullaitivu': {
      'minLat': 8.5,
      'maxLat': 9.0,
      'minLng': 81.3,
      'maxLng': 81.9,
    },
    'Batticaloa': {
      'minLat': 7.5,
      'maxLat': 8.2,
      'minLng': 81.5,
      'maxLng': 81.9,
    },
    'Ampara': {'minLat': 7.0, 'maxLat': 7.8, 'minLng': 81.5, 'maxLng': 82.0},
    'Trincomalee': {
      'minLat': 8.3,
      'maxLat': 9.0,
      'minLng': 81.1,
      'maxLng': 81.7,
    },
    'Kurunegala': {
      'minLat': 6.8,
      'maxLat': 7.5,
      'minLng': 80.2,
      'maxLng': 80.7,
    },
    'Puttalam': {'minLat': 7.6, 'maxLat': 8.3, 'minLng': 79.7, 'maxLng': 80.2},
    'Anuradhapura': {
      'minLat': 7.9,
      'maxLat': 8.7,
      'minLng': 80.3,
      'maxLng': 80.9,
    },
    'Polonnaruwa': {
      'minLat': 7.9,
      'maxLat': 8.4,
      'minLng': 81.0,
      'maxLng': 81.6,
    },
    'Badulla': {'minLat': 6.9, 'maxLat': 7.4, 'minLng': 81.0, 'maxLng': 81.6},
    'Monaragala': {
      'minLat': 6.6,
      'maxLat': 7.2,
      'minLng': 81.2,
      'maxLng': 81.8,
    },
    'Ratnapura': {'minLat': 6.6, 'maxLat': 7.1, 'minLng': 80.4, 'maxLng': 80.9},
    'Kegalle': {'minLat': 7.1, 'maxLat': 7.6, 'minLng': 80.4, 'maxLng': 80.9},
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

      Get.snackbar(
        'Success',
        'Location detected successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
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

      Get.snackbar('Success', 'Ad created successfully');
      clearForm();
      Get.back();
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
