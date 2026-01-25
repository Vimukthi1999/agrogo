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
            margin: EdgeInsets.only(bottom: 7, top: 7),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
                ),
                child: BottomNavigationBar(
                  currentIndex: controller.selectedIndex.value,

                  onTap: controller.changePage,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, size: 25),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home, size: 25),
                      label: 'Capture Images',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings, size: 25),
                      label: 'Profile',
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
