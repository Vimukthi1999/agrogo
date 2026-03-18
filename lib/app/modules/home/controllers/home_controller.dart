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

  void clearSearch() {
    searchQuery.value = "";
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

  // void fetchCategories() async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('categories')
  //         .get();

  //     categories.value = snapshot.docs
  //         .map((doc) => CategoryModel.fromFirestore(doc.id, doc.data()))
  //         .toList();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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
