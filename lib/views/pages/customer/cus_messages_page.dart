import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CusMessagesPage extends StatelessWidget {
  const CusMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: AppColors().white,
        elevation: 0,
        title: Text(
          'Messages',
          style: TextStyle(color: AppColors().black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors().orange),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Messages List
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Adjust this for the number of messages
                itemBuilder: (context, index) {
                  return const MessageItem();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors().white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors().grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/teacher.jpg'),
          ),
          const SizedBox(width: 12),
          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Haneen daoud',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hi how are you?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors().grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Timestamp and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Sun, 12:40pm',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors().grey,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.check_circle,
                color: AppColors().green,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
