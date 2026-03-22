import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../favorites/controllers/favorites_controller.dart';
import '../nav/controllers/nav_controller.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String? quantity;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic>? data;
  final VoidCallback? onTap;

  const ProductCard({
    Key? key,
    required this.title,
    required this.price,
    this.quantity,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.data,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      color: Colors.grey[50],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey[300],
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        if (quantity != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            "Available: $quantity kg",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2D9B5F),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.orange, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  rating.toString(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Obx(() {
                          bool isFarmerMode = false; // default
                          bool isFav = false;
                          
                          try {
                            if (Get.isRegistered<NavController>()) {
                              isFarmerMode = Get.find<NavController>().isFarmerMode.value;
                            }
                            if (Get.isRegistered<FavoritesController>()) {
                              final favCtrl = Get.find<FavoritesController>();
                              if (data != null && data!.containsKey('id')) {
                                isFav = favCtrl.isFavorite(data!['id']);
                              }
                            }
                          } catch (_) {}

                          if (isFarmerMode) {
                            return const SizedBox.shrink(); // Hide or disable favorite in farmer mode
                          }

                          return GestureDetector(
                            onTap: () {
                              if (data != null && data!.containsKey('id')) {
                                if (Get.isRegistered<FavoritesController>()) {
                                  Get.find<FavoritesController>().toggleFavorite(data!, data!['id']);
                                } else {
                                  Get.snackbar("Notice", "Favorites system not ready.");
                                }
                              } else {
                                Get.snackbar("Notice", "Cannot favorite this item (missing ID).");
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isFav ? Colors.red.withValues(alpha: 0.1) : const Color(0xFF1E7044),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFav ? Colors.red : Colors.white,
                                size: 16,
                              ),
                            ),
                          );
                        }),
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
