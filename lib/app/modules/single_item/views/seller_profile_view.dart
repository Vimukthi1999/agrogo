import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../chat/controllers/chat_controller.dart';
import '../../chat/views/chat_room_view.dart';
import '../../common/item_card.dart';

class SellerProfileView extends StatelessWidget {
  final Map<String, dynamic> sellerData;
  final int listingsCount;

  const SellerProfileView({
    super.key,
    required this.sellerData,
    required this.listingsCount,
  });

  String _formatMemberSince(dynamic timestamp) {
    if (timestamp == null) return 'Member';
    DateTime date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else {
      return 'Member';
    }
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return 'Member since ${months[date.month - 1]} ${date.year}';
  }

  String _getAccountTypeLabel(String? type) {
    if (type == null) return 'Seller';
    return type[0].toUpperCase() + type.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final sellerId = sellerData['uid'] ?? '';
    final profileImage = sellerData['profileImage'] ?? '';
    final name = sellerData['name'] ?? 'Unknown Seller';
    final district = sellerData['district'] ?? '';
    final province = sellerData['province'] ?? '';
    final phone = sellerData['phone'] ?? '';
    final email = sellerData['email'] ?? '';
    final accountType = sellerData['accountType'] ?? sellerData['role'] ?? 'seller';
    final createdAt = sellerData['createdAt'];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // --- App Bar with gradient ---
          SliverAppBar(
            expandedHeight: 280,
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
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E7044),
                      Color(0xFF2D9B5F),
                      Color(0xFF45B87A),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Profile Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          backgroundImage: profileImage.isNotEmpty
                              ? NetworkImage(profileImage)
                              : null,
                          child: profileImage.isEmpty
                              ? Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : 'S',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Name
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Account type badge + location
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getAccountTypeLabel(accountType),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (district.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.location_on, color: Colors.white70, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              district,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- Stats Row ---
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildStatItem(
                    icon: Icons.storefront_rounded,
                    label: 'Listings',
                    value: '$listingsCount',
                    color: const Color(0xFF1E7044),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey[200],
                  ),
                  _buildStatItem(
                    icon: Icons.verified_user_rounded,
                    label: 'Status',
                    value: 'Verified',
                    color: const Color(0xFF2D9B5F),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey[200],
                  ),
                  _buildStatItem(
                    icon: Icons.calendar_today_rounded,
                    label: _formatMemberSince(createdAt),
                    value: '',
                    color: Colors.orange,
                    isDate: true,
                  ),
                ],
              ),
            ),
          ),

          // --- Contact Info ---
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E7044),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (phone.isNotEmpty)
                    _buildContactRow(
                      icon: Icons.phone_rounded,
                      label: phone,
                      onTap: () async {
                        final Uri launchUri = Uri(scheme: 'tel', path: phone);
                        if (await canLaunchUrl(launchUri)) {
                          await launchUrl(launchUri);
                        }
                      },
                    ),
                  if (phone.isNotEmpty && district.isNotEmpty)
                    Divider(color: Colors.grey[100], height: 24),
                  if (district.isNotEmpty)
                    _buildContactRow(
                      icon: Icons.location_on_rounded,
                      label: '$district${province.isNotEmpty ? ", $province" : ""}',
                    ),
                  if (email.isNotEmpty) ...[
                    Divider(color: Colors.grey[100], height: 24),
                    _buildContactRow(
                      icon: Icons.email_rounded,
                      label: email,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // --- Action Buttons ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Call Button
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.phone_in_talk_rounded,
                      label: 'Call',
                      color: const Color(0xFF1E7044),
                      onTap: () async {
                        if (phone.isNotEmpty) {
                          final Uri launchUri = Uri(scheme: 'tel', path: phone);
                          if (await canLaunchUrl(launchUri)) {
                            await launchUrl(launchUri);
                          }
                        } else {
                          Get.snackbar('Notice', 'Phone number not available.',
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Chat Button
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.chat_bubble_rounded,
                      label: 'Chat',
                      color: const Color(0xFF2D9B5F),
                      onTap: () => _startChat(sellerId, name),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Seller's Listings Header ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                '$name\'s Listings',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E7044),
                ),
              ),
            ),
          ),

          // --- Seller's Listings Grid ---
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('listings')
                .where('sellerId', isEqualTo: sellerId)
                .where('status', isEqualTo: 'active')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(color: Color(0xFF1E7044)),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(Icons.storefront_outlined, size: 60, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text(
                            'No active listings',
                            style: TextStyle(color: Colors.grey[500], fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final listings = snapshot.data!.docs;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final doc = listings[index];
                      final data = doc.data() as Map<String, dynamic>;
                      data['id'] = doc.id;
                      final images = data['images'] as List<dynamic>? ?? [];

                      return ProductCard(
                        title: data['title'] ?? 'Untitled',
                        price: 'Rs. ${data['price']}',
                        quantity: data['quantity']?.toString(),
                        imageUrl: images.isNotEmpty ? images[0] : '',
                        rating: 4.8,
                        reviewCount: 0,
                        data: data,
                        onTap: () {
                          Get.toNamed('/single-item', arguments: data);
                        },
                      );
                    },
                    childCount: listings.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isDate = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          if (value.isNotEmpty) const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDate ? 11 : 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E7044).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF1E7044), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (onTap != null)
              Icon(Icons.open_in_new_rounded, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startChat(String sellerId, String sellerName) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      Get.snackbar('Error', 'Please sign in to chat.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (sellerId.isEmpty || sellerId == currentUser.uid) {
      Get.snackbar('Notice', 'You cannot chat with yourself.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final currentUserName = currentUserDoc.data()?['name'] ?? 'User';

      if (!Get.isRegistered<ChatController>()) {
        Get.put(ChatController());
      }
      final chatController = Get.find<ChatController>();

      final chatId = await chatController.getOrCreateChatRoom(
        otherUserId: sellerId,
        otherUserName: sellerName,
        currentUserName: currentUserName,
      );

      Get.back(); // Close loading dialog

      Get.to(() => ChatRoomView(
            chatId: chatId,
            otherUserName: sellerName,
            otherUserId: sellerId,
          ));
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Could not start chat. Try again.',
          snackPosition: SnackPosition.BOTTOM);
      debugPrint('Chat error: $e');
    }
  }
}
