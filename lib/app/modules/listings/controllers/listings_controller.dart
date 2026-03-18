import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ListingsController extends GetxController {
  final listings = <QueryDocumentSnapshot>[].obs;
  final isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final selectedCategoryId = ''.obs;
  final selectedCategoryName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      selectedCategoryId.value = args['categoryId'] ?? '';
      selectedCategoryName.value = args['categoryName'] ?? '';
    }
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
      
      var filteredDocs = snapshot.docs;
      
      // Client-side filtering to avoid requiring a custom composite index in Firestore
      if (selectedCategoryId.value.isNotEmpty) {
        filteredDocs = filteredDocs.where((doc) {
          final data = doc.data();
          return data['category'] == selectedCategoryId.value;
        }).toList();
      }

      listings.assignAll(filteredDocs);
      isLoading.value = false;
    }, onError: (error) {
      print("Firestore Error: $error");
      Get.snackbar('Error', 'Failed to fetch listings. Please try again.');
      isLoading.value = false;
    });
  }
}
