import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  
  final loadingUpdateMe = false.obs;
  final loadingUpdatePw = false.obs;

  final currentPwController = TextEditingController();
  final newPwController = TextEditingController();
  final confirmPwController = TextEditingController();

  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // final ThemeController foundThemeController = Get.find();


  @override
  void onInit() {
    super.onInit();
  }

  Future<void> updateAboutMe() async {}

  Future<void> updatePw() async {}

  Future<void> logout() async {}

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
