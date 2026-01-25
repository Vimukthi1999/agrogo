import 'package:agrogo/app/modules/settings/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../home/bindings/home_binding.dart';
import '../../home/views/home_view.dart';
import '../../settings/bindings/settings_binding.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<String> pages = [];

  @override
  void onInit() {
    super.onInit();
    setPages();
  }

  void setPages() {
    pages.add(Routes.HOME);
    pages.add(Routes.SIGNUP);
    pages.add(Routes.SETTINGS);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.HOME) {
      return GetPageRoute(
        settings: settings,
        page: () => const HomeView(),
        binding: HomeBinding(),
      );
    }
    if (settings.name == Routes.SETTINGS) {
      return GetPageRoute(
        settings: settings,
        page: () => const SettingsView(),
        binding: SettingsBinding(),
      );
    }

    // if (settings.name == Routes.IMAGES_SUBMIT) {
    //   return GetPageRoute(
    //     settings: settings,
    //     page: () => const ImagesSubmitView(),
    //     binding: ImagesSubmitBinding(),
    //   );
    // }

    return null;
  }

  void changePage(int index) {
    selectedIndex.value = index;
    Get.offAndToNamed(pages[index], id: 1);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
