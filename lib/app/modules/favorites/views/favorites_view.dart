import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/category_model.dart';
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
                  // Search Bar with Filter Icon
                  Row(
                    children: [
                      Expanded(
                        child: Container(
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
                                  : Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: controller.hasActiveFilters
                                  ? Border.all(
                                      color: const Color(0xFFFFAB40),
                                      width: 2,
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
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
                  // Active Filters Chips
                  Obx(() {
                    if (!controller.hasActiveFilters) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
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

  Widget _buildFilterChip(IconData icon, String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
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
              color: Colors.white.withValues(alpha: 0.7),
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
      builder: (context) => _FilterBottomSheet(controller: controller),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.filter_list_off, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                "No items match your filters".tr,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
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
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show result count when filters are active
        Obx(() {
          if (!controller.hasActiveFilters) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              "${filteredItems.length} results found".tr,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
        GridView.builder(
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
        ),
      ],
    );
  }
}

// --- Filter Bottom Sheet Widget ---
class _FilterBottomSheet extends StatelessWidget {
  final FavoritesController controller;

  const _FilterBottomSheet({required this.controller});

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
                  'Filter Favorites',
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
                      items: controller.availableLocations,
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
                  color: Colors.black.withValues(alpha: 0.05),
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
                color: const Color(0xFF1E7044).withValues(alpha: 0.1),
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
                        color: const Color(0xFF1E7044).withValues(alpha: 0.3),
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
