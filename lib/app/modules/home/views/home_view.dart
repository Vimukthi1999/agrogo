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

                  // Search Bar + Filter Icon Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
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
                                        controller.clearSearch();
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Color(0xFF1E7044),
                                        size: 22,
                                      ),
                                    )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          )),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Filter Icon Button
                      Obx(
                        () => GestureDetector(
                          onTap: () => _showFilterBottomSheet(context),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: controller.hasActiveFilters
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: controller.hasActiveFilters
                                  ? Border.all(
                                      color: const Color(0xFFFFAB40),
                                      width: 2,
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  color: controller.hasActiveFilters
                                      ? const Color(0xFF1E7044)
                                      : Colors.white,
                                  size: 22,
                                ),
                                if (controller.activeFilterCount.value > 0)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFAB40),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${controller.activeFilterCount.value}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Active Filter Chips
                  Obx(() {
                    if (!controller.hasActiveFilters) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (controller.filterLocation.value.isNotEmpty &&
                              controller.filterLocation.value != 'All')
                            _buildFilterChip(
                              Icons.location_on_outlined,
                              controller.filterLocation.value,
                              () => controller.setLocation(''),
                            ),
                          if (controller.filterProvince.value.isNotEmpty &&
                              controller.filterProvince.value != 'All')
                            _buildFilterChip(
                              Icons.map_outlined,
                              controller.filterProvince.value,
                              () => controller.setProvince(''),
                            ),
                          if (controller.filterDistrict.value.isNotEmpty &&
                              controller.filterDistrict.value != 'All')
                            _buildFilterChip(
                              Icons.place_outlined,
                              controller.filterDistrict.value,
                              () => controller.setDistrict(''),
                            ),
                          if (controller.filterCategory.value.isNotEmpty &&
                              controller.filterCategory.value != 'All')
                            _buildFilterChip(
                              Icons.category_outlined,
                              controller.filterCategory.value,
                              () => controller.setCategory(''),
                            ),
                        ],
                      ),
                    );
                  }),

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
                        final filteredAds = controller.applyFilters(snapshot.data!.docs);

                        if (filteredAds.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                                  const SizedBox(height: 10),
                                  Text(
                                    controller.hasActiveFilters
                                        ? "No items match your filters.".tr
                                        : "No items found matching your search.".tr,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  if (controller.hasActiveFilters) ...[
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: controller.clearAllFilters,
                                      icon: const Icon(Icons.clear_all, color: Color(0xFF1E7044)),
                                      label: Text(
                                        "Clear all filters".tr,
                                        style: const TextStyle(color: Color(0xFF1E7044)),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show result count when filters are active
                            if (controller.hasActiveFilters)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 8),
                                child: Text(
                                  "${filteredAds.length} results found".tr,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            GridView.builder(
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
                            ),
                          ],
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

  Widget _buildFilterChip(IconData icon, String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E7044).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF1E7044).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF1E7044)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1E7044),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14,
              color: const Color(0xFF1E7044).withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _HomeFilterBottomSheet(controller: controller),
    );
  }
}

// --- Filter Bottom Sheet Widget ---
class _HomeFilterBottomSheet extends StatelessWidget {
  final HomeController controller;

  const _HomeFilterBottomSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E7044),
                  ),
                ),
                Row(
                  children: [
                    Obx(() {
                      if (!controller.hasActiveFilters) {
                        return const SizedBox.shrink();
                      }
                      return TextButton(
                        onPressed: () {
                          controller.clearAllFilters();
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Filter Options
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Filter
                  _buildFilterSection(
                    context,
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    subtitle: 'Filter by item location',
                    child: Obx(() => _buildChipGroup(
                      items: controller.allDistrictsList,
                      selectedValue: controller.filterLocation.value,
                      onSelected: (value) => controller.setLocation(value),
                    )),
                  ),
                  const SizedBox(height: 24),

                  // Province Filter
                  _buildFilterSection(
                    context,
                    icon: Icons.map_outlined,
                    title: 'Province',
                    subtitle: 'Filter by province',
                    child: Obx(() => _buildChipGroup(
                      items: controller.provinces,
                      selectedValue: controller.filterProvince.value,
                      onSelected: (value) => controller.setProvince(value),
                    )),
                  ),
                  const SizedBox(height: 24),

                  // District Filter
                  _buildFilterSection(
                    context,
                    icon: Icons.place_outlined,
                    title: 'District',
                    subtitle: 'Filter by district',
                    child: Obx(() => _buildChipGroup(
                      items: controller.districts,
                      selectedValue: controller.filterDistrict.value,
                      onSelected: (value) => controller.setDistrict(value),
                    )),
                  ),
                  const SizedBox(height: 24),

                  // Category Filter  
                  _buildFilterSection(
                    context,
                    icon: Icons.category_outlined,
                    title: 'Categories',
                    subtitle: 'Filter by product category',
                    child: StreamBuilder<List<CategoryModel>>(
                      stream: controller.getCategories(),
                      builder: (context, snapshot) {
                        final categoryNames = <String>['All'];
                        if (snapshot.hasData) {
                          categoryNames.addAll(
                            snapshot.data!.map((c) => c.id),
                          );
                        }
                        return Obx(() => _buildChipGroup(
                          items: categoryNames,
                          selectedValue: controller.filterCategory.value,
                          onSelected: (value) => controller.setCategory(value),
                        ));
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Apply Button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E7044),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Obx(() => Text(
                  controller.hasActiveFilters
                      ? 'Apply Filters (${controller.activeFilterCount.value})'
                      : 'Apply Filters',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E7044).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF1E7044)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildChipGroup({
    required List<String> items,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = item == selectedValue ||
            (item == 'All' && (selectedValue.isEmpty || selectedValue == 'All'));
        return GestureDetector(
          onTap: () => onSelected(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1E7044)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1E7044)
                    : Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF1E7044).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              item,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
