import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FavoritesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FavoritesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
