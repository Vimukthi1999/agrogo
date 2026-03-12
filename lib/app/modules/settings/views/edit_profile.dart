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
            
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              
              Text(
                'Name'.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextFormField(
               
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.boy, size: 20),
                  hintText: 'Name'.tr,
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 10),

              
              Text(
                'Email'.tr,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextFormField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.sms, size: 20),
                  hintText: 'Email'.tr,
                ),
                
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 10),

              
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

    
  }
}
