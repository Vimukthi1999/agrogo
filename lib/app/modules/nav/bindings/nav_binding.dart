import 'package:get/get.dart';

import '../controllers/nav_controller.dart';
import '../../home/bindings/home_binding.dart';
import '../../myads/bindings/myads_binding.dart';
import '../../favorites/bindings/favorites_binding.dart';
import '../../settings/bindings/settings_binding.dart';
import '../../chat/bindings/chat_binding.dart';

class NavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavController>(() => NavController());
    HomeBinding().dependencies();
    MyadsBinding().dependencies();
    FavoritesBinding().dependencies();
    SettingsBinding().dependencies();
    ChatBinding().dependencies();
  }
}
