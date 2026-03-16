import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';

class HomeController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchCategories();
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
