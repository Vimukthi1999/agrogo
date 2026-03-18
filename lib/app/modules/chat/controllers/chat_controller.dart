import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final conversations = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final unreadCount = 0.obs;

  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
    listenToUnreadCount();
  }

  /// Listen to conversations for the current user (real-time)
  void fetchConversations() {
    if (currentUserId.isEmpty) return;

    isLoading.value = true;

    _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .listen((snapshot) {
      conversations.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['chatId'] = doc.id;
        return data;
      }).toList();
      isLoading.value = false;
    }, onError: (e) {
      isLoading.value = false;
      log('Error fetching conversations: $e');
    });
  }

  /// Listen for total unread messages across all conversations
  void listenToUnreadCount() {
    if (currentUserId.isEmpty) return;

    _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .listen((snapshot) {
      int total = 0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final unreadMap = data['unreadCount'] as Map<String, dynamic>? ?? {};
        total += (unreadMap[currentUserId] as int?) ?? 0;
      }
      unreadCount.value = total;
    });
  }

  /// Get or create a chat room between current user and another user
  Future<String> getOrCreateChatRoom({
    required String otherUserId,
    required String otherUserName,
    required String currentUserName,
    String? adId,
    String? adTitle,
    String? adImage,
  }) async {
    // Check if a chat already exists between these two users
    final existingChats = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .get();

    for (final doc in existingChats.docs) {
      final participants = List<String>.from(doc.data()['participants'] ?? []);
      if (participants.contains(otherUserId)) {
        return doc.id;
      }
    }

    // Create a new chat room
    final chatDoc = await _firestore.collection('chats').add({
      'participants': [currentUserId, otherUserId],
      'participantNames': {
        currentUserId: currentUserName,
        otherUserId: otherUserName,
      },
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastSenderId': '',
      'unreadCount': {
        currentUserId: 0,
        otherUserId: 0,
      },
      'adId': adId,
      'adTitle': adTitle,
      'adImage': adImage,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return chatDoc.id;
  }

  /// Send a message in a chat room
  Future<void> sendMessage({
    required String chatId,
    required String message,
    required String receiverId,
  }) async {
    if (message.trim().isEmpty) return;

    final batch = _firestore.batch();

    // Add message
    final messageRef =
        _firestore.collection('chats').doc(chatId).collection('messages').doc();
    batch.set(messageRef, {
      'senderId': currentUserId,
      'message': message.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });

    // Update chat room metadata
    final chatRef = _firestore.collection('chats').doc(chatId);
    batch.update(chatRef, {
      'lastMessage': message.trim(),
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastSenderId': currentUserId,
      'unreadCount.$receiverId': FieldValue.increment(1),
    });

    // Add notification for the receiver
    final notifRef = _firestore.collection('notifications').doc();
    batch.set(notifRef, {
      'userId': receiverId,
      'type': 'message',
      'title': 'New Message',
      'body': message.trim(),
      'senderId': currentUserId,
      'chatId': chatId,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Mark messages as read when opening a chat room
  Future<void> markChatAsRead(String chatId) async {
    // Reset unread count for current user
    await _firestore.collection('chats').doc(chatId).update({
      'unreadCount.$currentUserId': 0,
    });

    // Mark all unread messages from the other user as read
    // Only query on 'read' field to avoid needing a composite index,
    // then filter by senderId in code.
    final unreadMessages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('read', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in unreadMessages.docs) {
      // Filter in code: only mark messages from the OTHER user as read
      if (doc.data()['senderId'] != currentUserId) {
        batch.update(doc.reference, {'read': true});
      }
    }
    await batch.commit();
  }

  /// Get the other participant's name from a chat document
  String getOtherUserName(Map<String, dynamic> chat) {
    final names = chat['participantNames'] as Map<String, dynamic>? ?? {};
    for (final entry in names.entries) {
      if (entry.key != currentUserId) {
        return entry.value.toString();
      }
    }
    return 'Unknown User';
  }

  /// Get the other participant's ID from a chat document
  String getOtherUserId(Map<String, dynamic> chat) {
    final participants = List<String>.from(chat['participants'] ?? []);
    for (final id in participants) {
      if (id != currentUserId) return id;
    }
    return '';
  }

  /// Get unread count for current user in a specific chat
  int getUnreadForChat(Map<String, dynamic> chat) {
    final unreadMap = chat['unreadCount'] as Map<String, dynamic>? ?? {};
    return (unreadMap[currentUserId] as int?) ?? 0;
  }

  /// Delete a conversation
  Future<void> deleteConversation(String chatId) async {
    Get.defaultDialog(
      title: 'Delete Conversation',
      middleText: 'This will permanently delete this conversation.',
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            Get.back();
            // Delete messages subcollection
            final messages = await _firestore
                .collection('chats')
                .doc(chatId)
                .collection('messages')
                .get();
            final batch = _firestore.batch();
            for (final doc in messages.docs) {
              batch.delete(doc.reference);
            }
            batch.delete(_firestore.collection('chats').doc(chatId));
            await batch.commit();

            Get.snackbar('Success', 'Conversation deleted',
                snackPosition: SnackPosition.BOTTOM);
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  /// Format timestamp for display
  String formatTime(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else {
      return '';
    }

    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
