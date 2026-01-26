import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  colors: [
                    Color(0xFF1E7044),
                    Color(0xFF2D9B5F),
                  ],
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
                        color: Colors.white.withOpacity(0.7),
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
                          color: Colors.black.withOpacity(0.1),
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

            // Filter Section
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Filter by Category".tr,
            //         style: const TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold,
            //           color: Color(0xFF1E7044),
            //         ),
            //       ),
            //       const SizedBox(height: 12),
            //       SizedBox(
            //         height: 40,
            //         child: Obx(
            //           () => ListView.builder(
            //             scrollDirection: Axis.horizontal,
            //             itemCount: controller.categories.length,
            //             itemBuilder: (context, index) {
            //               final category = controller.categories[index];
            //               final isSelected =
            //                   controller.filterCategory.value == category;

            //               return Padding(
            //                 padding: const EdgeInsets.only(right: 8),
            //                 child: GestureDetector(
            //                   onTap: () => controller.setCategory(category),
            //                   child: Container(
            //                     padding: const EdgeInsets.symmetric(
            //                       horizontal: 16,
            //                       vertical: 8,
            //                     ),
            //                     decoration: BoxDecoration(
            //                       color: isSelected
            //                           ? const Color(0xFF1E7044)
            //                           : Colors.grey[100],
            //                       borderRadius: BorderRadius.circular(20),
            //                       border: Border.all(
            //                         color: isSelected
            //                             ? const Color(0xFF1E7044)
            //                             : Colors.grey[300]!,
            //                       ),
            //                     ),
            //                     child: Text(
            //                       category,
            //                       style: TextStyle(
            //                         fontSize: 12,
            //                         fontWeight: FontWeight.w600,
            //                         color: isSelected
            //                             ? Colors.white
            //                             : Colors.grey[700],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             },
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

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
                color: const Color(0xFF1E7044).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 64,
                color: const Color(0xFF1E7044).withOpacity(0.5),
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
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
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              "No items found".tr,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
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
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildFavoritesCard(item);
      },
    );
  }

  Widget _buildFavoritesCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage(item['image'] ?? ''),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                  child: (item['image'] == null || item['image'].isEmpty)
                      ? Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                        )
                      : null,
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => controller.removeFromFavorites(item['id']),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // Discount Badge
                if (item['originalPrice'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '15% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Text(
                      item['category'] ?? 'N/A',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Title
                    Text(
                      item['title'] ?? 'Product',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E7044),
                      ),
                    ),
                    const Spacer(),
                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star_half,
                          size: 14,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${item['rating'] ?? '0'} (${item['reviews'] ?? '0'})",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price
                    Row(
                      children: [
                        Text(
                          item['price'] ?? '₹0',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E7044),
                          ),
                        ),
                        if (item['originalPrice'] != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            item['originalPrice'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
