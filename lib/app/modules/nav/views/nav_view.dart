import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/nav_controller.dart';

class NavView extends GetView<NavController> {
  const NavView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (controller.selectedIndex.value != 0) {
          controller.changePage(0);
          return;
        } else {
          Get.defaultDialog(
            title: 'Exit',
            middleText: 'Are you sure you want to exit?',
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: const Text('Yes'),
              ),
            ],
          );
        }
      },
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Navigator(
          key: Get.nestedKey(1),
          initialRoute: Routes.HOME,
          onGenerateRoute: controller.onGenerateRoute,
        ),
        bottomNavigationBar: Obx(
          () => Container(
            margin: const EdgeInsets.only(bottom: 7, top: 7),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
                ),
                child: BottomNavigationBar(
                  currentIndex: controller.selectedIndex.value,
                  onTap: controller.changePage,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: const Color(0xFF1E7044),
                  unselectedItemColor: Colors.grey[400],
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 11,
                  ),
                  iconSize: 24,
                  elevation: 5,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home_outlined),
                      activeIcon: const Icon(Icons.home),
                      label: 'Home'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.post_add_outlined),
                      activeIcon: const Icon(Icons.post_add),
                      label: 'My Ads'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.favorite_outline),
                      activeIcon: const Icon(Icons.favorite),
                      label: 'Favorites'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person_outline),
                      activeIcon: const Icon(Icons.person),
                      label: 'Profile'.tr,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
