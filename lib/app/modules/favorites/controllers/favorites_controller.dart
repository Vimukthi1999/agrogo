import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final favoriteItems = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final filterCategory = ''.obs;

  // Categories for filtering
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

  // Fetch favorite items from Firebase
  void fetchFavorites() {
    isLoading.value = true;
    try {
      // TODO: Fetch from Firestore where isFavorited == true
      favoriteItems.value = [];
      
      // Sample data for testing
      // favoriteItems.value = [
      //   {
      //     'id': '1',
      //     'title': 'Premium Organic Seeds',
      //     'price': '₹500',
      //     'originalPrice': '₹750',
      //     'image': 'https://via.placeholder.com/200',
      //     'category': 'Seeds',
      //     'rating': 4.5,
      //     'reviews': 124,
      //     'distance': '5 km away',
      //     'seller': 'Farmer John',
      //   },
      // ];
    } finally {
      isLoading.value = false;
    }
  }

  // Get filtered items based on search and category
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

  // Remove from favorites
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
            // TODO: Update Firebase
            favoriteItems.removeWhere((item) => item['id'] == itemId);
            Get.back();
            Get.snackbar('Success', 'Removed from favorites');
          },
          child: const Text('Remove', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  // Share item
  void shareItem(String title) {
    Get.snackbar('Share', 'Sharing "$title"');
    // TODO: Implement share functionality
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
  }

  // Set category filter
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
