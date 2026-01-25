import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/app_dialogBox.dart';
import '../controllers/settings_controller.dart';
import 'change_pw.dart';
import 'edit_profile.dart';
import 'profile_menu_card.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings'.tr,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Account Settings Card
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
                    Text("Account Settings".tr,
                        style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 5),
                    Text("Customize your account settings".tr,
                        style: Theme.of(context).textTheme.bodySmall),
                    SizedBox(height: 15),
                    ProfileMenuCard(
                      title: "Edit Profile".tr,
                      subTitle: "Change your profile details".tr,
                      press: () {
                        // Navigate to edit profile page
                        Get.to(() => const EditProfile());
                      },
                    ),
                    ProfileMenuCard(
                      title: "Change Password".tr,
                      subTitle: "Change your password".tr,
                      press: () {
                        // Navigate to change password page
                        Get.to(() => const ChangePw());
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            /// App Settings Card
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
                    Text("App Settings".tr,
                        style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 5),
                    Text("Customize your app settings".tr,
                        style: Theme.of(context).textTheme.bodySmall),
                    SizedBox(height: 15),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Change App Theme".tr,
                              style: Theme.of(context).textTheme.titleSmall),
                          // Obx(
                          //   () => Switch(
                          //     value:
                          //         controller.foundThemeController.isDarkMode(),
                          //     onChanged: (bool value) {
                          //       controller.foundThemeController.toggleThemeMode(
                          //         value ? ThemeMode.dark : ThemeMode.light,
                          //       );
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    ProfileMenuCard(
                      title: "Change Language".tr,
                      subTitle:
                          "Selected Language: ".tr,
                      press: () {
                        
                        // showChangeLanguageDialog();
                      },
                    ),

                    // Text(
                    //   "Change App Color",
                    //   style: Theme.of(context).textTheme.titleSmall,
                    // ),
                    // SizedBox(height: 5.h),
                    // ColorChanageDropdown(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            /// More Section Card
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
                    SizedBox(height: 5),
                    // ProfileMenuCard(
                    //   title: "About Us",
                    //   subTitle: "Learn more about us",
                    //   press: () {},
                    // ),
                    // ProfileMenuCard(
                    //   title: "Privacy Policy",
                    //   subTitle: "Learn more about our privacy policy",
                    //   press: () {},
                    // ),
                    // ProfileMenuCard(
                    //   title: "Terms and Conditions",
                    //   subTitle: "Learn more about our terms and conditions",
                    //   press: () {},
                    // ),
                    // ProfileMenuCard(
                    //   title: "Help Center",
                    //   subTitle: "Get help from our support team",
                    //   press: () {},
                    // ),

                    ProfileMenuCard(
                      title: "Logout".tr,
                      subTitle: "Logout from your account".tr,
                      press: () async {
                        // controller.logout();
                        // apiFailedWithErrors(
                        // "Logout",
                        // [
                        //   "Are you sure you want to logout?",
                        //   "This will remove your account from this device.",
                        // ],
                        // );

                        // apiFailedWithUnauthorized(
                        //   "Logout",
                        //   [
                        //     "Are you sure you want to logout?",
                        //     "This will remove your account from this device.",
                        //   ],
                        // );

                        // showYesNoAppDialog(
                        //   "Logout",
                        //   "Are you sure you want to logout?",
                        // );

                        final shouldExit = await showAppExitDialog();
                        if (shouldExit) {
                          // Perform logout action
                          controller.logout();
                        }
                      },
                    ),

                    SizedBox(height: 10),
                    Text(
                      "Version: 1.0.0",
                      // "Version: ".tr + dotenv.env['APPVERSION']!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
