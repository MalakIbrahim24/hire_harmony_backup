import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors().orange : AppColors().white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 2.5),
      child: Text(
        message,
        style: TextStyle(color: isCurrentUser ? AppColors().white : AppColors().black,
         fontSize: 16,
         fontWeight: FontWeight.bold
         ),
      ),
    );
  }
}
