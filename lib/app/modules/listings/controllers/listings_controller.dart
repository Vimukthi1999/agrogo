import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ListingsController extends GetxController {
  final listings = <QueryDocumentSnapshot>[].obs;
  final isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAllAds();
  }

  void fetchAllAds() {
    isLoading.value = true;
    _firestore
        .collection('listings')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      listings.assignAll(snapshot.docs);
      isLoading.value = false;
    }, onError: (error) {
      Get.snackbar('Error', 'Failed to fetch categories. Please try again.');
      isLoading.value = false;
    });
  }
}
