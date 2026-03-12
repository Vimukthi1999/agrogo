import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> showAppExitDialog() async {
  final shouldExit = await showDialog(
    context: Get.context!,
    builder: (context) => AlertDialog(
      title: Text(
        'Exit App'.tr,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      content: Text('Are you sure you want to exit?'.tr),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('NO'.tr),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('YES'.tr),
        ),
      ],
    ),
  );

  return shouldExit ?? false;
}