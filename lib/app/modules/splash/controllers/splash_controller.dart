import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(vsync: this);
  }

  // void startAnimation() {
  //   animationController
  //     ..duration = Duration(seconds: 5)
  //     ..forward().whenComplete(() {
  //       Get.offAllNamed('/home');
  //       animationController.forward();
  //     });
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }
}
