import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

// Custom Widget for Notifications
class NotificationItem extends StatelessWidget {
  final String username;
  final String action;
  final String time;
  final bool isRead; // Added isRead flag

  const NotificationItem({
    super.key,
    required this.username,
    required this.action,
    required this.time,
    this.isRead = false, // Default to false if not provided
  });

  // Factory method to create NotificationItem from Firestore data
  factory NotificationItem.fromFirebase(Map<String, dynamic> data) {
    return NotificationItem(
      username: data['username'] ?? 'Unknown User',
      action: data['action'] ?? 'performed an action',
      time: data['time'] != null
          ? (data['time'] is String
              ? data['time']
              : data['time'].toDate().toString())
          : 'Just now',
      isRead: data['read'] ?? false, // Default to false if 'read' is missing
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        backgroundColor: isRead ? AppColors().grey : AppColors().orange,
        radius: 25,
        child: const Icon(Icons.notifications, color: Colors.white, size: 28),
      ),
      title: RichText(
        text: TextSpan(
          style: GoogleFonts.montserratAlternates(
            fontSize: 16,
            color: AppColors().white,
          ),
          children: [
            TextSpan(
              text: '$username ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: action),
          ],
        ),
      ),
      subtitle: Text(
        time,
        style: GoogleFonts.montserratAlternates(
          fontSize: 12,
          color: AppColors().grey.withValues(alpha: 0.7),
        ),
      ),
      trailing: isRead
          ? null
          : const Icon(Icons.fiber_manual_record, color: Colors.red, size: 12),
    );
  }
}

// Custom Divider for Notifications
class NotificationDivider extends StatelessWidget {
  const NotificationDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.grey,
      thickness: 0.3,
      indent: 70,
      endIndent: 10,
    );
  }
}
