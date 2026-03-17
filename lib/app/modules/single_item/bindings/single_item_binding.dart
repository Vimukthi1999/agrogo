import 'package:get/get.dart';

import '../controllers/single_item_controller.dart';

class SingleItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SingleItemController>(
      () => SingleItemController(),
    );
  }
}
