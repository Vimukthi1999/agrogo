import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/single_item_controller.dart';

class SingleItemView extends GetView<SingleItemController> {
  const SingleItemView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SingleItemView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SingleItemView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
