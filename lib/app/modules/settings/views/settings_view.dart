import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/app_dialogBox.dart';
import '../controllers/settings_controller.dart';
import '../../nav/controllers/nav_controller.dart';
import 'change_pw.dart';
import 'edit_profile.dart';
import 'profile_menu_card.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  
  @override
  Widget build(BuildContext context) {
    final navController = Get.find<NavController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E7044), Color(0xFF2D9B5F)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settings".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Settings".tr,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Customize your account settings".tr,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          ProfileMenuCard(
                            title: "Edit Profile".tr,
                            subTitle: "Change your profile details".tr,
                            press: () {
                              Get.to(() => const EditProfile());
                            },
                          ),
                          ProfileMenuCard(
                            title: "Change Password".tr,
                            subTitle: "Change your password".tr,
                            press: () {
                              Get.to(() => const ChangePw());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "App Settings".tr,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Customize your app settings".tr,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Obx(() => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                               padding: const EdgeInsets.all(8),
                               decoration: BoxDecoration(
                                 color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                 shape: BoxShape.circle,
                               ),
                                 child: Icon(
                                   controller.isDarkMode.value 
                                     ? Icons.dark_mode 
                                     : Icons.light_mode,
                                   color: Theme.of(context).colorScheme.primary,
                                 ),
                             ),
                            title: Text(
                              "Dark Mode".tr,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              controller.isDarkMode.value 
                                ? "Switch to light mode".tr 
                                : "Switch to dark mode".tr,
                              style: const TextStyle(fontSize: 11),
                            ),
                             trailing: Switch(
                               value: controller.isDarkMode.value,
                               activeColor: Theme.of(context).colorScheme.primary,
                               onChanged: (value) => controller.switchTheme(),
                             ),
                          )),
                          ProfileMenuCard(
                            title: "Change Language".tr,
                            subTitle: "Selected Language: ".tr,
                            press: () {},
                          ),
                          const Divider(),
                          Obx(() => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                               child: Icon(
                                 navController.isFarmerMode.value 
                                   ? Icons.agriculture 
                                   : Icons.shopping_cart,
                                 color: Theme.of(context).colorScheme.primary,
                               ),
                            ),
                            title: Text(
                              navController.isFarmerMode.value 
                                ? "Farmer Mode".tr 
                                : "Buyer Mode".tr,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            subtitle: Text(
                              navController.isFarmerMode.value 
                                ? "Switch to Buyer mode to browse and buy".tr 
                                : "Switch to Farmer mode to list and sell".tr,
                              style: const TextStyle(fontSize: 11),
                            ),
                             trailing: Switch(
                               value: navController.isFarmerMode.value,
                               activeColor: Theme.of(context).colorScheme.primary,
                               onChanged: (value) => navController.toggleRole(),
                             ),
                          )),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "More".tr,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          ProfileMenuCard(
                            title: "Logout",
                            subTitle: "Logout from your account",
                            press: () async {
                              final shouldExit = await showAppExitDialog();
                              if (shouldExit) {
                                controller.logout();
                              }
                            },
                          ),

                          SizedBox(height: 5),
                          Text(
                            "Version: 1.0.0",

                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
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
