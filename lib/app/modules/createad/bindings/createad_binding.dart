import 'package:get/get.dart';

import '../controllers/createad_controller.dart';

class CreateadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateadController>(() => CreateadController());
  }
}
