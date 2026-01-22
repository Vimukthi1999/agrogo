import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());
  }

  // Register
  Future<void> register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
