import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/createad_controller.dart';

class CreateadView extends GetView<CreateadController> {
  const CreateadView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateadView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreateadView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
