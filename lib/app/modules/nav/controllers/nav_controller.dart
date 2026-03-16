import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
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
