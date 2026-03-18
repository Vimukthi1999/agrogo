import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      final matchesSearch = item['title'].toString().toLowerCase().contains(
        searchQuery.value.toLowerCase(),
      );
      final matchesCategory =
          filterCategory.value.isEmpty ||
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
