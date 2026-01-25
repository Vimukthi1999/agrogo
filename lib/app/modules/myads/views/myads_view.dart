import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/myads_controller.dart';

class MyadsView extends GetView<MyadsController> {
  const MyadsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyadsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyadsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
