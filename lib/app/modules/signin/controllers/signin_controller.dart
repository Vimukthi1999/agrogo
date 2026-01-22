import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SigninController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
  }

  // Login
  Future<void> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar("Error", e.toString());
      log(e.toString());
    }
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
