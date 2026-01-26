import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class ChangePw extends GetView<SettingsController> {
  const ChangePw({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password'.tr,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        centerTitle: true,
        // showbackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          // key: controller.changePwFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// current pw
              Text(
                'Current Password'.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Obx(
                () => TextFormField(
                  obscureText: !controller.isCurrentPasswordVisible.value,
                  controller: controller.currentPwController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, size: 20),
                    hintText: 'Password'.tr,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isCurrentPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.isCurrentPasswordVisible.value =
                            !controller.isCurrentPasswordVisible.value;
                      },
                    ),
                  ),
                  // validator: (value) => AValidator.validateText(
                  //   value,
                  //   'Password'.tr,
                  // ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              SizedBox(height: 10),

              /// new pw
              Text(
                'New Password'.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Obx(
                () => TextFormField(
                  obscureText: !controller.isNewPasswordVisible.value,
                  controller: controller.newPwController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, size: 20),
                    hintText: 'Password'.tr,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isNewPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.isNewPasswordVisible.value =
                            !controller.isNewPasswordVisible.value;
                      },
                    ),
                  ),
                  // validator: (value) => AValidator.validateText(
                  //   value,
                  //   'New Password'.tr,
                  // ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

              SizedBox(height: 10),

              /// confirm pw
              Text(
                'Confirm Password'.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Obx(
                () => TextFormField(
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  controller: controller.confirmPwController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, size: 20),
                    hintText: 'Password'.tr,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.isConfirmPasswordVisible.value =
                            !controller.isConfirmPasswordVisible.value;
                      },
                    ),
                  ),
                  // validator: (value) => AValidator.validateConfirmPassword(
                  //   value,
                  //   controller.newPwController.text,
                  // ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),

              SizedBox(height: 10),

              /// Save Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => OutlinedButton(
                    onPressed: controller.updatePw,
                    child: controller.loadingUpdatePw.value
                        ? const CircularProgressIndicator.adaptive()
                        : Text(
                            'Save'.tr,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
