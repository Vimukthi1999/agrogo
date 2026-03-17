import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/myads_controller.dart';

class MyadsView extends GetView<MyadsController> {
  const MyadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    "My Ads".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Manage and track your listings".tr,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.CREATEAD);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFF1E7044),
                        size: 22,
                      ),
                      label: Text(
                        "Create New Ad".tr,
                        style: const TextStyle(
                          color: Color(0xFF1E7044),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Listings".tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E7044),
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) => controller.selectedStatus.value = value,
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'All', child: Text('All Listings')),
                          const PopupMenuItem(value: 'Active', child: Text('Active Only')),
                          const PopupMenuItem(value: 'Inactive', child: Text('Inactive Only')),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF1E7044).withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF1E7044).withOpacity(0.05),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.filter_list,
                                size: 18,
                                color: Color(0xFF1E7044),
                              ),
                              const SizedBox(width: 6),
                              Obx(() => Text(
                                controller.selectedStatus.value.tr,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF1E7044),
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Obx(
                    () => controller.filteredAds.isEmpty
                        ? _buildEmptyState(
                            isFilter: controller.selectedStatus.value != 'All',
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.filteredAds.length,
                            itemBuilder: (context, index) {
                              final ad = controller.filteredAds[index];
                              return _buildAdCard(ad);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({bool isFilter = false}) {
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
                isFilter ? Icons.search_off : Icons.post_add_outlined,
                size: 64,
                color: const Color(0xFF1E7044).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isFilter ? "No Matches Found".tr : "No Ads Yet".tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E7044),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isFilter 
                  ? "Try changing your filter settings".tr 
                  : "Create your first ad to get started".tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdCard(DocumentSnapshot doc) {
    final ad = doc.data() as Map<String, dynamic>;
    final adId = doc.id;
    final images = ad['images'] as List<dynamic>?;
    final imageUrl = (images != null && images.isNotEmpty) ? images[0] : '';

    return Container(
      key: ValueKey('${doc.id}_${ad['status']}_${ad['updatedAt']}'),
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            width: 110,
            height: 110,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? Icon(Icons.image_not_supported, color: Colors.grey[400])
                : null,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad['title'] ?? 'Untitled',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E7044),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ad['category'] ?? 'N/A',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rs. ${ad['price']} / kg",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E7044),
                            ),
                          ),
                          Text(
                            "Qty: ${ad['quantity']} kg",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(ad['status']),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          (ad['status'] ?? 'active').toString().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                controller.editAd(doc);
              } else if (value == 'delete') {
                controller.deleteAd(adId);
              } else if (value == 'status') {
                controller.toggleAdStatus(adId, ad['status'] ?? 'active');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'status',
                child: Row(
                  children: [
                    Icon(
                      (ad['status'] ?? 'active').toString().toLowerCase() == 'active'
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      (ad['status'] ?? 'active').toString().toLowerCase() == 'active'
                          ? 'Make Inactive'
                          : 'Make Active',
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: Color(0xFF1E7044)),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return const Color(0xFF1E7044);
      case 'inactive':
        return Colors.grey[600]!;
      case 'pending':
        return Colors.orange;
      case 'sold':
        return Colors.blueGrey;
      case 'expired':
        return Colors.red;
      default:
        return const Color(0xFF1E7044);
    }
  }
}
