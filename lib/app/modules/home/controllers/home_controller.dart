import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';

class HomeController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final isLoading = true.obs;
  final userName = "User".obs;
  final profileImage = "".obs;
  final searchQuery = "".obs;

  // Filter state
  final filterCategory = ''.obs;
  final filterProvince = ''.obs;
  final filterDistrict = ''.obs;
  final filterLocation = ''.obs;
  final activeFilterCount = 0.obs;

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

  List<String> get allDistrictsList => [
    'All',
    ...provinceDistricts.values.expand((d) => d).toList()..sort(),
  ];

  bool get hasActiveFilters => activeFilterCount.value > 0;

  void clearSearch() {
    searchQuery.value = "";
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

  /// Apply all filters (search + location/province/district/category) to a list of ad docs
  List<QueryDocumentSnapshot> applyFilters(List<QueryDocumentSnapshot> docs) {
    final query = searchQuery.value.toLowerCase();

    return docs.where((doc) {
      final ad = doc.data() as Map<String, dynamic>;

      // Search filter
      if (query.isNotEmpty) {
        final title = (ad['title'] ?? '').toString().toLowerCase();
        final description = (ad['description'] ?? '').toString().toLowerCase();
        if (!title.contains(query) && !description.contains(query)) {
          return false;
        }
      }

      // Category filter
      if (filterCategory.value.isNotEmpty && filterCategory.value != 'All') {
        if (ad['category'] != filterCategory.value) return false;
      }

      // Province filter
      if (filterProvince.value.isNotEmpty && filterProvince.value != 'All') {
        if (ad['province'] != filterProvince.value) return false;
      }

      // District filter
      if (filterDistrict.value.isNotEmpty && filterDistrict.value != 'All') {
        if (ad['district'] != filterDistrict.value) return false;
      }

      // Location filter
      if (filterLocation.value.isNotEmpty && filterLocation.value != 'All') {
        if (ad['district'] != filterLocation.value) return false;
      }

      return true;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            userName.value = data['name'] ?? "User";
            profileImage.value = data['profileImage'] ?? "";
          }
        }
      }, onError: (error) {
        log('Error fetching user data: $error');
      });
    }
  }

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

  Stream<QuerySnapshot> getRecentAds() {
    return FirebaseFirestore.instance
        .collection('listings')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();
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
