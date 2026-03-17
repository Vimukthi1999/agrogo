import 'package:get/get.dart';

class SingleItemController extends GetxController {
  late Map<String, dynamic> ad;
  final currentImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ad = Get.arguments as Map<String, dynamic>? ?? {};
  }

  void updateImageIndex(int index) {
    currentImageIndex.value = index;
  }
}
