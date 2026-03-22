import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../chat/views/chat_room_view.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  String get _currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E7044), Color(0xFF2D9B5F)],
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _markAllAsRead(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Mark all read',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notifications list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', isEqualTo: _currentUserId)
                  .orderBy('createdAt', descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }

                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || (snapshot.data!.docs.isEmpty && snapshot.connectionState != ConnectionState.waiting)) {
                  return _buildEmptyState();
                }

                final notifications = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif =
                        notifications[index].data() as Map<String, dynamic>;
                    final notifId = notifications[index].id;
                    return _buildNotificationTile(context, notif, notifId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
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
                Icons.notifications_none_rounded,
                size: 64,
                color: const Color(0xFF1E7044).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E7044),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You\'re all caught up!\nNotifications will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    bool isIndexError = error.contains('index');
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              isIndexError ? 'Index Required' : 'Oops!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isIndexError
                  ? 'This view requires a Firestore composite index. You can create it in the Firebase Console using the link that should appear in your debug logs.'
                  : 'Something went wrong: $error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (isIndexError) ...[
                const SizedBox(height: 16),
                const Text(
                  'Note: To fix this quickly, you can temporarily remove the sorting in notifications_view.dart (line 86).',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    Map<String, dynamic> notif,
    String notifId,
  ) {
    final isRead = notif['read'] ?? false;
    final type = notif['type'] ?? 'general';
    final title = notif['title'] ?? 'Notification';
    final body = notif['body'] ?? '';
    final createdAt = notif['createdAt'] as Timestamp?;

    IconData icon;
    Color iconColor;

    switch (type) {
      case 'message':
        icon = Icons.chat_bubble_rounded;
        iconColor = const Color(0xFF1E7044);
        break;
      case 'favorite':
        icon = Icons.favorite_rounded;
        iconColor = Colors.red;
        break;
      case 'listing':
        icon = Icons.inventory_2_rounded;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.notifications_rounded;
        iconColor = const Color(0xFF1E7044);
    }

    return InkWell(
      onTap: () async {
        // Mark as read
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(notifId)
            .update({'read': true});

        // Navigate based on type
        if (type == 'message' && notif['chatId'] != null) {
          // Get chat details for navigation
          final chatDoc = await FirebaseFirestore.instance
              .collection('chats')
              .doc(notif['chatId'])
              .get();

          if (chatDoc.exists) {
            final chatData = chatDoc.data()!;
            final participants =
                List<String>.from(chatData['participants'] ?? []);
            final names =
                chatData['participantNames'] as Map<String, dynamic>? ?? {};

            String otherUserId = '';
            String otherUserName = 'User';
            for (final id in participants) {
              if (id != _currentUserId) {
                otherUserId = id;
                otherUserName = names[id] ?? 'User';
                break;
              }
            }

            Get.to(() => ChatRoomView(
                  chatId: notif['chatId'],
                  otherUserName: otherUserName,
                  otherUserId: otherUserId,
                  adTitle: chatData['adTitle'],
                ));
          }
        }
      },
      child: Container(
        color: isRead ? Colors.white : const Color(0xFF1E7044).withOpacity(0.04),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isRead ? FontWeight.w500 : FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E7044),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  if (createdAt != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _markAllAsRead() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: _currentUserId)
        .where('read', isEqualTo: false)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();

    Get.snackbar(
      'Done',
      'All notifications marked as read',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E7044),
      colorText: Colors.white,
    );
  }
}
