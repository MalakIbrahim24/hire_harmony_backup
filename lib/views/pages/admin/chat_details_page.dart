import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class ChatDetailsPage extends StatefulWidget {
  final String chatName;

  const ChatDetailsPage({
    super.key,
    required this.chatName,
  });

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, String>> messages = [
    {'sender': 'admin', 'message': 'Hello, how can I help you?'},
    {'sender': 'user', 'message': 'I need assistance with my account.'},
  ];

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        messages.add({'sender': 'user', 'message': messageText});
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: AppColors().navy,
        iconTheme: IconThemeData(
          color: AppColors().white, // Set back arrow color to white
        ),
        title: Text(
          widget.chatName,
          style: GoogleFonts.montserratAlternates(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors().white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors().orange
                            : AppColors().white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isUser ? 15 : 0),
                          topRight: Radius.circular(isUser ? 0 : 15),
                          bottomLeft: const Radius.circular(15),
                          bottomRight: const Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        message['message']!,
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 16,
                          color: isUser ? AppColors().white : AppColors().navy,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors().white.withValues(alpha:0.9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: GoogleFonts.montserratAlternates(
                        color: AppColors().grey,
                      ),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.montserratAlternates(
                      color: AppColors().navy,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: AppColors().orange),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
