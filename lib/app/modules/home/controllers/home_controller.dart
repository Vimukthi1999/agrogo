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
    return FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .map((snapshot) {
          log('Categories snapshot: ${snapshot.docs.length}');
          return snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.id, doc.data()))
              .toList();
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
