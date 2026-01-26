import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile'.tr,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        centerTitle: true,
        // showbackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
            // key: controller.editProfileFormKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /// name
              Text(
                'Name'.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextFormField(
                // controller: controller.nameController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.boy, size: 20),
                  hintText: 'Name'.tr,
                ),
                // validator: (value) => AValidator.validateText(value, 'Name'.tr),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 10),

              /// email
              Text(
                'Email'.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextFormField(
                // controller: controller.emailController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.sms, size: 20),
                  hintText: 'Email'.tr,
                ),
                // validator: (value) => AValidator.validateText(value, 'Email'.tr),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 10),

              /// Save Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => OutlinedButton(
                    onPressed: controller.updateAboutMe,
                    child: controller.loadingUpdateMe.value
                        ? const CircularProgressIndicator.adaptive()
                        : Text(
                            'Save'.tr,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                  ),
                ),
              ),
            ])),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    // if (controller.nameController.text.isEmpty ||
    //     controller.nameController.text !=
    //         controller.foundUserController.user.value.name) {
    //   controller.nameController.text =
    //       controller.foundUserController.user.value.name;
    // }
    // if (controller.emailController.text.isEmpty ||
    //     controller.emailController.text !=
    //         controller.foundUserController.user.value.email) {
    //   controller.emailController.text =
    //       controller.foundUserController.user.value.email;
    // }
  }
}
