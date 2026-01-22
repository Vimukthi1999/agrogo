import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {


// Data for "Invest by Category"
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.hourglass_bottom, 'label': 'Duration', 'color': Colors.blue},
    {'icon': Icons.monetization_on, 'label': 'Return', 'color': Colors.green},
    {'icon': Icons.trending_down, 'label': 'Low Risk', 'color': Colors.redAccent},
    {'icon': Icons.shield, 'label': 'Safety', 'color': Colors.orange},
  ];
  
  @override
  void onInit() {
    super.onInit();
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
