import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E7044),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E7044).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chat_bubble_outline, size: 80, color: const Color(0xFF1E7044).withOpacity(0.5)),
            ),
            const SizedBox(height: 24),
            Text(
              'No messages yet'.tr,
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E7044),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your conversations will appear here'.tr,
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
}
