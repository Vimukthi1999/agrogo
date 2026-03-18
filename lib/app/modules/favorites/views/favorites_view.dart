import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../common/item_card.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E7044), Color(0xFF2D9B5F)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Favorites".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      "${controller.favoriteItems.length} items saved".tr,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Obx(
                      () => TextField(
                        onChanged: (value) {
                          controller.searchQuery.value = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Search favorites...".tr,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF1E7044),
                          ),
                          suffixIcon: controller.searchQuery.isNotEmpty
                              ? GestureDetector(
                                  onTap: controller.clearSearch,
                                  child: const Icon(
                                    Icons.close,
                                    color: Color(0xFF1E7044),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Favorites List
            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(
                () => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.favoriteItems.isEmpty
                    ? _buildEmptyState()
                    : _buildFavoritesList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFF1E7044).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 64,
                color: const Color(0xFF1E7044).withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No Favorites Yet".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E7044),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Start adding items to your favorites".tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    final filteredItems = controller.getFilteredItems();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              "No items found".tr,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.7,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final ad = filteredItems[index];
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
          data: ad,
          onTap: () {
            Get.toNamed(Routes.SINGLE_ITEM, arguments: ad);
          },
        );
      },
    );
  }
}
