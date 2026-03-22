import 'package:agrogo/app/modules/favorites/views/favorites_view.dart';
import 'package:agrogo/app/modules/myads/views/myads_view.dart';
import 'package:agrogo/app/modules/settings/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nav_controller.dart';
import '../../home/views/home_view.dart';
import '../../chat/views/chat_view.dart';
import '../../chat/controllers/chat_controller.dart';

class NavView extends GetView<NavController> {
  const NavView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ChatController is registered for unread count listening
    if (!Get.isRegistered<ChatController>()) {
      Get.put(ChatController(), permanent: true);
    }
    final chatController = Get.find<ChatController>();

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
        resizeToAvoidBottomInset: false,
        body: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.isFarmerMode.value 
              ? const [
                  HomeView(),
                  MyadsView(),
                  ChatView(),
                  SettingsView(),
                ]
              : const [
                  HomeView(),
                  FavoritesView(),
                  ChatView(),
                  SettingsView(),
                ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            margin: const EdgeInsets.only(bottom: 7, top: 7),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                onTap: controller.changePage,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(fontSize: 11),
                iconSize: 24,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined),
                    activeIcon: const Icon(Icons.home),
                    label: 'Home'.tr,
                  ),
                  controller.isFarmerMode.value 
                    ? BottomNavigationBarItem(
                        icon: const Icon(Icons.inventory_2_outlined),
                        activeIcon: const Icon(Icons.inventory_2),
                        label: 'My Ads'.tr,
                      )
                    : BottomNavigationBarItem(
                        icon: const Icon(Icons.favorite_outline),
                        activeIcon: const Icon(Icons.favorite),
                        label: 'Favorites'.tr,
                      ),
                  BottomNavigationBarItem(
                    icon: Obx(() {
                      final unread = chatController.unreadCount.value;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.chat_outlined),
                          if (unread > 0)
                            Positioned(
                              top: -4,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF4444),
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    unread > 9 ? '9+' : '$unread',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    activeIcon: Obx(() {
                      final unread = chatController.unreadCount.value;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.chat),
                          if (unread > 0)
                            Positioned(
                              top: -4,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFF4444),
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    unread > 9 ? '9+' : '$unread',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    label: 'Chats'.tr,
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
    );
  }
}
