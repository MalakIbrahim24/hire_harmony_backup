// ignore_for_file: file_names


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/component/chat_bubble.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:hire_harmony/services/chat/chat_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/notifcation_service.dart';

class Chatepage extends StatefulWidget {
  final String reciverEmail;
  final String reciverID;
  final String? reciverName;
  final String? chatController;


  const Chatepage(
      {super.key,
      required this.reciverEmail,
      required this.reciverID,
      this.reciverName,
      this.chatController});

  @override
  State<Chatepage> createState() => _ChatepageState();
}

class _ChatepageState extends State<Chatepage> {
  final ChatServices _chatServices = ChatServices();

  final AuthServices _authServices = AuthServicesImpl();

  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController =
      ScrollController(); 
 // ScrollController
      String fcmToken = "";

   void sendMessage() async {
  if (_messageController.text.isNotEmpty) {
    try {
      // 1. إرسال الرسالة إلى Firestore
      await _chatServices.sendMessages(
        widget.reciverID,
        _messageController.text,
      );

      // 2. الحصول على Token الخاص بالمستلم
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.reciverID)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        fcmToken = userDoc.get("fcmToken") ?? "";

        // 3. إرسال إشعار عبر FCM إذا كان هناك FCM Token
        if (fcmToken.isNotEmpty) {
          LocalNotificationService.sendNotification(
            title: 'New message',
            message: _messageController.text,
            token: fcmToken,
          );
        }
      }

      // 4. مسح حقل الإدخال بعد الإرسال
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}

  void _scrollToBottom() {
    // Scroll to bottom
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<String> _getChatControllerStatus(String chatRoomID) async {
    // Fetch the chat room's document
    final chatRoomDoc = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomID)
        .get();

    if (chatRoomDoc.exists) {
      final data = chatRoomDoc.data() as Map<String, dynamic>;
      return data['chatController'] ?? 'closed'; // Default to 'closed'
    }

    throw Exception('Chat room does not exist.');
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserID = _authServices.getCurrentUser()!.uid;

    // Generate chatRoomID in a consistent order
    final String chatRoomID = currentUserID.compareTo(widget.reciverID) < 0
        ? '${currentUserID}_${widget.reciverID}'
        : '${widget.reciverID}_$currentUserID';

    return FutureBuilder<String>(
      future: _getChatControllerStatus(chatRoomID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading Chat...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error loading chat: ${snapshot.error}')),
          );
        }

        // If the chatController is "open", show the chat interface
        if (snapshot.data == 'open') {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.reciverName ?? 'Unknown',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Colors.grey,
              elevation: 0,
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://e0.pxfuel.com/wallpapers/722/149/desktop-wallpaper-message-background-whatsapp-message-background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  // Message list
                  Expanded(
                    child: _buildMessageList(),
                  ),
                  // User input
                  _buildUserInput(),
                ],
              ),
            ),
          );
        } else {
          // If the chatController is "closed", lock the page
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.reciverName ?? 'Unknown',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Colors.grey,
              elevation: 0,
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'This chat room is locked.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You cannot access this chat right now.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildMessageList() {
    final senderID = _authServices.getCurrentUser()!.uid;

    return StreamBuilder(
      stream: _chatServices.getMessage(senderID, widget.reciverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("ERROR");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading ...");
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("No messages yet.");
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom(); // Scroll to bottom after loading messages
        });

        return ListView(
          controller: _scrollController, // Bind ScrollController
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        data['senderID'] == _authServices.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerLeft : Alignment.centerRight;

    return Container(
        alignment: alignment,
        child: Column(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)
          ],
        ));
  }

  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      color: Colors.grey[200],
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey[600]),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 5.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Container(
            decoration: BoxDecoration(
              color: AppColors().orange,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors().orange.withAlpha(100),
                  blurRadius: 6.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: AppColors().white),
              onPressed: () {
                sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
