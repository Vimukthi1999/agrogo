import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';

class FavoritesController extends GetxController {
  final favoriteItems = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  // Filter state
  final filterCategory = ''.obs;
  final filterProvince = ''.obs;
  final filterDistrict = ''.obs;
  final filterLocation = ''.obs;

  // Track active filter count for badge
  final activeFilterCount = 0.obs;

  final categories = <String>[
    'All',
    'Seeds',
    'Vegetables',
    'Fruits',
    'Fertilizers',
    'Tools',
    'Equipment',
  ].obs;

  // Sri Lanka provinces and districts
  final Map<String, List<String>> provinceDistricts = {
    'Western': ['Colombo', 'Gampaha', 'Kalutara'],
    'Central': ['Kandy', 'Matale', 'Nuwara Eliya'],
    'Southern': ['Galle', 'Matara', 'Hambantota'],
    'Northern': ['Jaffna', 'Kilinochchi', 'Mannar', 'Vavuniya', 'Mullaitivu'],
    'Eastern': ['Batticaloa', 'Ampara', 'Trincomalee'],
    'North Western': ['Kurunegala', 'Puttalam'],
    'North Central': ['Anuradhapura', 'Polonnaruwa'],
    'Uva': ['Badulla', 'Monaragala'],
    'Sabaragamuwa': ['Ratnapura', 'Kegalle'],
  };

  List<String> get provinces => ['All', ...provinceDistricts.keys];

  List<String> get districts {
    if (filterProvince.value.isEmpty || filterProvince.value == 'All') {
      // Return all districts
      return [
        'All',
        ...provinceDistricts.values.expand((d) => d),
      ];
    }
    return [
      'All',
      ...provinceDistricts[filterProvince.value] ?? [],
    ];
  }

  // Dynamically extract unique locations from favorite items
  List<String> get availableLocations {
    final locations = <String>{};
    for (final item in favoriteItems) {
      final district = item['district']?.toString() ?? '';
      if (district.isNotEmpty) {
        locations.add(district);
      }
    }
    return ['All', ...locations.toList()..sort()];
  }

  // Dynamically extract unique categories from favorite items
  List<String> get availableCategories {
    final cats = <String>{};
    for (final item in favoriteItems) {
      final category = item['category']?.toString() ?? '';
      if (category.isNotEmpty) {
        cats.add(category);
      }
    }
    return ['All', ...cats.toList()..sort()];
  }

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  void fetchFavorites() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    isLoading.value = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      favoriteItems.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // ensure ad ID is kept
        return data;
      }).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      debugPrint("Error fetching favorites: $e");
    });
  }

  bool isFavorite(String adId) {
    return favoriteItems.any((item) => item['id'] == adId);
  }

  Future<void> toggleFavorite(Map<String, dynamic> ad, String adId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Please sign in to add favorites');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(adId);

    if (isFavorite(adId)) {
      await docRef.delete();
      Get.snackbar('Success', 'Removed from favorites', snackPosition: SnackPosition.BOTTOM);
    } else {
      await docRef.set(ad);
      Get.snackbar('Success', 'Added to favorites', snackPosition: SnackPosition.BOTTOM);
    }
  }

  List<Map<String, dynamic>> getFilteredItems() {
    return favoriteItems.where((item) {
      // Search filter
      final matchesSearch = item['title'].toString().toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );

      // Category filter
      final matchesCategory =
          filterCategory.value.isEmpty ||
          filterCategory.value == 'All' ||
          item['category'] == filterCategory.value;

      // Province filter
      final matchesProvince =
          filterProvince.value.isEmpty ||
          filterProvince.value == 'All' ||
          item['province'] == filterProvince.value;

      // District filter
      final matchesDistrict =
          filterDistrict.value.isEmpty ||
          filterDistrict.value == 'All' ||
          item['district'] == filterDistrict.value;

      // Location filter (same as district effectively, for user-friendly naming)
      final matchesLocation =
          filterLocation.value.isEmpty ||
          filterLocation.value == 'All' ||
          item['district'] == filterLocation.value;

      return matchesSearch &&
          matchesCategory &&
          matchesProvince &&
          matchesDistrict &&
          matchesLocation;
    }).toList();
  }

  void removeFromFavorites(String itemId) {
    Get.defaultDialog(
      title: 'Remove Favorite',
      middleText: 'Remove this item from your favorites?',
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            Get.back();
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('favorites')
                  .doc(itemId)
                  .delete();
            }
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
    _updateActiveFilterCount();
  }

  void setProvince(String province) {
    filterProvince.value = province;
    // Reset district when province changes
    filterDistrict.value = '';
    _updateActiveFilterCount();
  }

  void setDistrict(String district) {
    filterDistrict.value = district;
    _updateActiveFilterCount();
  }

  void setLocation(String location) {
    filterLocation.value = location;
    _updateActiveFilterCount();
  }

  void clearAllFilters() {
    filterCategory.value = '';
    filterProvince.value = '';
    filterDistrict.value = '';
    filterLocation.value = '';
    _updateActiveFilterCount();
  }

  void _updateActiveFilterCount() {
    int count = 0;
    if (filterCategory.value.isNotEmpty && filterCategory.value != 'All') count++;
    if (filterProvince.value.isNotEmpty && filterProvince.value != 'All') count++;
    if (filterDistrict.value.isNotEmpty && filterDistrict.value != 'All') count++;
    if (filterLocation.value.isNotEmpty && filterLocation.value != 'All') count++;
    activeFilterCount.value = count;
  }

  bool get hasActiveFilters => activeFilterCount.value > 0;

  // Get categories from Firebase for filter dropdown
  Stream<List<CategoryModel>> getCategories() {
    return FirebaseFirestore.instance.collection('categories').snapshots().map((
      snapshot,
    ) {
      if (snapshot.docs.isEmpty) return [];
      try {
        return snapshot.docs
            .map((doc) {
              try {
                final data = doc.data();
                if (!data.containsKey('name') || !data.containsKey('icon')) {
                  return null;
                }
                return CategoryModel.fromMap(doc.id, data);
              } catch (e) {
                return null;
              }
            })
            .whereType<CategoryModel>()
            .toList();
      } catch (e) {
        return [];
      }
    });
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
