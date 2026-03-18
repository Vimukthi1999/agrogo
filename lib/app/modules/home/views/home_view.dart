import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/category_model.dart';
import '../../../routes/app_pages.dart';
import '../../common/item_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E7044), Color(0xFF2D9B5F)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 6),
                          Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: const Color(0xFF1E7044).withOpacity(0.8),
                                backgroundImage: controller.profileImage.value.isNotEmpty
                                    ? NetworkImage(controller.profileImage.value)
                                    : null,
                                child: controller.profileImage.value.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  "Hello, ${controller.userName.value}".tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Sunday, 25 Jan 2026".tr,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle notification tap
                          // The instruction mentions adding navigation to Routes.LISTINGS,
                          // but the provided snippet for HomeView is malformed and seems to
                          // contain controller logic. Assuming the intent was to add navigation
                          // to the notification tap, but without Routes.LISTINGS defined,
                          // this part cannot be fully implemented as per the instruction.
                          // For now, keeping the original comment.
                          // If Routes.LISTINGS was available, it would be something like:
                          // Get.toNamed(Routes.LISTINGS);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Stack(
                            children: [
                              const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFFF4444),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Obx(() => TextField(
                      style: const TextStyle(
                        color: Color(0xFF1E7044),
                        fontSize: 14,
                      ),
                      onChanged: (val) {
                        controller.searchQuery.value = val;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search products, categories...".tr,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF1E7044),
                          size: 22,
                        ),
                        suffixIcon: controller.searchQuery.value.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  // Clear the text field contextually when tapped, but we only have controller here.
                                  // As a workaround for simple setup, just clearing the controller state works for UI changes
                                  controller.clearSearch();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xFF1E7044),
                                  size: 22,
                                ),
                              )
                            : const Icon(
                                Icons.filter_list,
                                color: Color(0xFF1E7044),
                                size: 22,
                              ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    )),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Categories".tr,
                    style: const TextStyle(
                      color: Color(0xFF1E7044),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 15),

                  StreamBuilder<List<CategoryModel>>(
                    stream: controller.getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.category_outlined,
                                size: 48,
                                color: Colors.white54,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No categories found',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final categories = snapshot.data!;

                      return SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];

                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.LISTINGS, arguments: {'categoryId': category.id, 'categoryName': category.name});
                              },
                              child: Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(
                                        0xFF1E7044,
                                      ).withOpacity(0.1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.network(
                                        category.icon,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Icon(
                                                Icons.image_not_supported,
                                                color: const Color(0xFF1E7044),
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                  Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E7044),
                                    ),
                                  ),
                                 ],
                              ),
                            ));
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fresh Deals".tr,
                        style: const TextStyle(
                          color: Color(0xFF1E7044),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.LISTINGS);
                        },
                        child: Text(
                          "View All".tr,
                          style: const TextStyle(
                            color: Color(0xFF2D9B5F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: controller.getRecentAds(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ));
                      }
                      
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),
                                const SizedBox(height: 10),
                                Text("No ads available yet".tr, style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        );
                      }

                      return Obx(() {
                        final query = controller.searchQuery.value.toLowerCase();
                        final filteredAds = snapshot.data!.docs.where((doc) {
                          if (query.isEmpty) return true;
                          final ad = doc.data() as Map<String, dynamic>;
                          final title = (ad['title'] ?? '').toString().toLowerCase();
                          final description = (ad['description'] ?? '').toString().toLowerCase();
                          return title.contains(query) || description.contains(query);
                        }).toList();

                        if (filteredAds.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                                  const SizedBox(height: 10),
                                  Text("No items found matching your search.".tr, style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(top: 15),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.7,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredAds.length,
                          itemBuilder: (context, index) {
                            final doc = filteredAds[index];
                            final ad = doc.data() as Map<String, dynamic>;
                            final adWithId = {...ad, 'id': doc.id};
                            
                            final images = ad['images'] as List<dynamic>?;
                            final imageUrl = (images != null && images.isNotEmpty) 
                                ? images[0] 
                                : "https://via.placeholder.com/150";
                            
                            return ProductCard(
                              title: ad['title'] ?? "Untitled",
                              price: "Rs. ${ad['price']} / kg",
                              quantity: ad['quantity']?.toString(),
                              imageUrl: imageUrl,
                              rating: 4.5, // Default for now
                              reviewCount: 0, // Default for now
                              data: adWithId,
                              onTap: () {
                                Get.toNamed(Routes.SINGLE_ITEM, arguments: adWithId);
                              },
                            );
                          },
                        );
                      });
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
