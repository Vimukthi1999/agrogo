import 'package:get/get.dart';
import '../controllers/listings_controller.dart';

class ListingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListingsController>(() => ListingsController());
  }
}
