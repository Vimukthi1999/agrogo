import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/TreeGreen.json',
              width: 150,
              height: 150,
              controller: controller.animationController,
              onLoaded: (composition) {
                // controller.animationController
                //   ..duration = composition.duration
                //   ..repeat();

                controller.animationController
                  ..duration = composition.duration
                  ..forward().whenComplete(() {
                    Get.offAllNamed('/signin');
                    // controller.animationController.forward();
                  });
              },
            ),
            RichText(
              text: TextSpan(
                text: 'Agro',
                style: TextStyle(
                  fontSize: 42,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: 'Go',
                    style: TextStyle(
                      fontSize: 42,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
