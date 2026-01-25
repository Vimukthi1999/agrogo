import 'package:get/get.dart';

import '../controllers/myads_controller.dart';

class MyadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyadsController>(
      () => MyadsController(),
    );
  }
}
