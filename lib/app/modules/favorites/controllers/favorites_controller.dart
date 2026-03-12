import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final favoriteItems = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final filterCategory = ''.obs;

  final categories = <String>[
    'All',
    'Seeds',
    'Vegetables',
    'Fruits',
    'Fertilizers',
    'Tools',
    'Equipment',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }


  void fetchFavorites() {
    isLoading.value = true;
    try {
      favoriteItems.value = [];
      
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> getFilteredItems() {
    return favoriteItems.where((item) {
      final matchesSearch = item['title']
          .toString()
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase());
      final matchesCategory = filterCategory.value.isEmpty ||
          filterCategory.value == 'All' ||
          item['category'] == filterCategory.value;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void removeFromFavorites(String itemId) {
    Get.defaultDialog(
      title: 'Remove Favorite',
      middleText: 'Remove this item from your favorites?',
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            favoriteItems.removeWhere((item) => item['id'] == itemId);
            Get.back();
            Get.snackbar('Success', 'Removed from favorites');
          },
          child: const Text('Remove', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }


  void shareItem(String title) {
    Get.snackbar('Share', 'Sharing "$title"');

  }


  void clearSearch() {
    searchQuery.value = '';
  }

 
  void setCategory(String category) {
    filterCategory.value = category;
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
