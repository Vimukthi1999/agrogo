import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateadController extends GetxController {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();


  final selectedImages = <XFile>[].obs;
  final selectedCategory = ''.obs;
  final selectedDistrict = ''.obs;
  final selectedTown = ''.obs;
  final userLocation = ''.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final isLoading = false.obs;


  final titleError = ''.obs;
  final descriptionError = ''.obs;
  final quantityError = ''.obs;
  final priceError = ''.obs;
  final imageError = ''.obs;
  final categoryError = ''.obs;


  final categories = <Map<String, dynamic>>[
    {'id': '1', 'name': 'Seeds', 'icon': 'https://via.placeholder.com/50'},
    {'id': '2', 'name': 'Vegetables', 'icon': 'https://via.placeholder.com/50'},
    {'id': '3', 'name': 'Fruits', 'icon': 'https://via.placeholder.com/50'},
    {'id': '4', 'name': 'Fertilizers', 'icon': 'https://via.placeholder.com/50'},
    {'id': '5', 'name': 'Tools', 'icon': 'https://via.placeholder.com/50'},
    {'id': '6', 'name': 'Equipment', 'icon': 'https://via.placeholder.com/50'},
  ].obs;


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

  @override
  void onInit() {
    super.onInit();

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
