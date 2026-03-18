import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../chat/controllers/chat_controller.dart';
import '../../chat/views/chat_room_view.dart';
import '../controllers/single_item_controller.dart';
import 'seller_profile_view.dart';

class SingleItemView extends GetView<SingleItemController> {
  const SingleItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final ad = controller.ad;
    final images = ad['images'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Custom Image Header
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                stretch: true,
                backgroundColor: const Color(0xFF1E7044),
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF1E7044)),
                    onPressed: () => Get.back(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (images.isNotEmpty)
                        PageView.builder(
                          controller: controller.pageController,
                          onPageChanged: controller.updateImageIndex,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              images[index],
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      else
                        Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey[400]),
                        ),
                      
                      // Gradient overlay for better text visibility
                      const Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black26,
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Custom Page Indicator
                      if (images.length > 1)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(images.length, (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                height: 8,
                                width: controller.currentImageIndex.value == index ? 24 : 8,
                                decoration: BoxDecoration(
                                  color: controller.currentImageIndex.value == index 
                                      ? Colors.white 
                                      : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            }),
                          )),
                        ),
                    ],
                  ),
                ),
              ),

              // Product Details
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge & Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E7044).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              (ad['category'] ?? "General").toString().toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF1E7044),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              const Text(
                                "4.8", // Mock
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ad['title'] ?? "Untitled Listing",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E7044),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Price & Quantity Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Price per kg",
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              Text(
                                "Rs. ${ad['price']}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2D9B5F),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey[100]!),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Stock Available",
                                  style: TextStyle(color: Colors.grey[500], fontSize: 10),
                                ),
                                Text(
                                  "${ad['quantity']} kg",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Divider(height: 1),
                      ),
                      
                      // Description
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E7044),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        ad['description'] ?? "No description provided for this item.",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.grey[700],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Seller Info Card
                      Obx(() {
                        final seller = controller.sellerData.value;
                        final profileImage = seller?['profileImage'] ?? '';
                        final sellerName = seller?['name'] ?? ad['sellerName'] ?? 'AgroGo Seller';
                        final sellerDistrict = seller?['district'] ?? ad['district'] ?? '';
                        final accountType = seller?['accountType'] ?? seller?['role'] ?? '';
                        final createdAt = seller?['createdAt'];
                        final listingsCount = controller.sellerListingsCount.value;

                        String memberSince = '';
                        if (createdAt != null && createdAt is Timestamp) {
                          final date = createdAt.toDate();
                          final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                          memberSince = 'Since ${months[date.month - 1]} ${date.year}';
                        }

                        return GestureDetector(
                          onTap: () {
                            if (seller != null) {
                              Get.to(() => SellerProfileView(
                                sellerData: seller,
                                listingsCount: listingsCount,
                              ));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF1E7044).withOpacity(0.12)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1E7044).withOpacity(0.06),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Profile Avatar
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF1E7044).withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor: const Color(0xFF1E7044).withOpacity(0.1),
                                        backgroundImage: profileImage.isNotEmpty
                                            ? NetworkImage(profileImage)
                                            : null,
                                        child: profileImage.isEmpty
                                            ? Text(
                                                sellerName.isNotEmpty ? sellerName[0].toUpperCase() : 'S',
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1E7044),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    // Name and info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  sellerName,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Color(0xFF222222),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              const Icon(
                                                Icons.verified_rounded,
                                                color: Color(0xFF2D9B5F),
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              if (accountType.isNotEmpty) ...[
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF1E7044).withOpacity(0.08),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    accountType[0].toUpperCase() + accountType.substring(1),
                                                    style: const TextStyle(
                                                      color: Color(0xFF1E7044),
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                              ],
                                              if (sellerDistrict.isNotEmpty) ...[
                                                Icon(Icons.location_on, size: 13, color: Colors.grey[500]),
                                                const SizedBox(width: 2),
                                                Text(
                                                  sellerDistrict,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Arrow
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E7044).withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xFF1E7044),
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                // Bottom stats row
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildMiniStat(
                                        Icons.storefront_rounded,
                                        '$listingsCount Listings',
                                      ),
                                      Container(height: 20, width: 1, color: Colors.grey[300]),
                                      _buildMiniStat(
                                        Icons.verified_user_outlined,
                                        'Verified',
                                      ),
                                      if (memberSince.isNotEmpty) ...[
                                        Container(height: 20, width: 1, color: Colors.grey[300]),
                                        _buildMiniStat(
                                          Icons.calendar_today_rounded,
                                          memberSince,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      
                      const SizedBox(height: 120), // Extra space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Sticky Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16), // Adjusted bottom padding
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                   // Chat Button
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E7044).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF1E7044)),
                      onPressed: () async {
                        final sellerId = ad['sellerId'];
                        final currentUser = FirebaseAuth.instance.currentUser;

                        if (currentUser == null) {
                          Get.snackbar('Error', 'Please sign in to chat.',
                              snackPosition: SnackPosition.BOTTOM);
                          return;
                        }

                        if (sellerId == null || sellerId == currentUser.uid) {
                          Get.snackbar('Notice', 'You cannot chat with yourself.',
                              snackPosition: SnackPosition.BOTTOM);
                          return;
                        }

                        // Show loading indicator
                        Get.dialog(
                          const Center(child: CircularProgressIndicator()),
                          barrierDismissible: false,
                        );

                        try {
                          // Fetch current user name
                          final currentUserDoc = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser.uid)
                              .get();
                          final currentUserName =
                              currentUserDoc.data()?['name'] ?? 'User';

                          // Fetch seller name
                          final sellerName = ad['sellerName'] ?? 'Seller';

                          // Get ad image for chat avatar
                          final images = ad['images'] as List<dynamic>?;
                          final adImage = (images != null && images.isNotEmpty)
                              ? images[0].toString()
                              : '';

                          // Ensure ChatController is available
                          if (!Get.isRegistered<ChatController>()) {
                            Get.put(ChatController());
                          }
                          final chatController = Get.find<ChatController>();

                          final chatId = await chatController.getOrCreateChatRoom(
                            otherUserId: sellerId,
                            otherUserName: sellerName,
                            currentUserName: currentUserName,
                            adId: ad['id'],
                            adTitle: ad['title'],
                            adImage: adImage,
                          );

                          Get.back(); // Close loading dialog

                          Get.to(() => ChatRoomView(
                                chatId: chatId,
                                otherUserName: sellerName,
                                otherUserId: sellerId,
                                adTitle: ad['title'],
                              ));
                        } catch (e) {
                          Get.back(); // Close loading dialog
                          Get.snackbar('Error', 'Could not start chat. Try again.',
                              snackPosition: SnackPosition.BOTTOM);
                          debugPrint('Chat error: $e');
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Location Button
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E7044).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.location_on_outlined, color: Color(0xFF1E7044)),
                      onPressed: () => controller.openLocationInMap(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Call Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => controller.makePhoneCall(),
                      icon: const Icon(Icons.phone_in_talk_rounded, size: 20),
                      label: const Text(
                        "Call Seller",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E7044),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF1E7044)),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
