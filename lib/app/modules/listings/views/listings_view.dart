import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/listings_controller.dart';
import '../../common/item_card.dart';

class ListingsView extends GetView<ListingsController> {
  const ListingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Ads'.tr),
        backgroundColor: const Color(0xFF1E7044),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          if (controller.isLoading.value && controller.listings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.listings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text("No listings available yet.".tr, style: TextStyle(color: Colors.grey[600])),
                ],
              )
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.7,
            ),
            itemCount: controller.listings.length,
            itemBuilder: (context, index) {
              final ad = controller.listings[index].data() as Map<String, dynamic>;
              final images = ad['images'] as List<dynamic>?;
              final imageUrl = (images != null && images.isNotEmpty) 
                  ? images[0] 
                  : "https://via.placeholder.com/150";

              return ProductCard(
                title: ad['title'] ?? 'Untitled',
                price: "Rs. ${ad['price']} / kg",
                quantity: ad['quantity']?.toString(),
                imageUrl: imageUrl,
                rating: 4.5, // Mock for now
                reviewCount: 0, // Mock for now
                onTap: () {
                  // TODO: Navigate to Ad Details
                },
              );
            },
          );
        }),
      ),
    );
  }
}
