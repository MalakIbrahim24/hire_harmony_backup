import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AdnNotificationsPage extends StatelessWidget {
  const AdnNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors().transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors().white,
              size: 25,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          'NOTIFICATIONS',
          style: GoogleFonts.montserratAlternates(
            color: AppColors().white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image with Blur Effect
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/notf.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Blur Filter
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
              child: Container(
                color: AppColors().navy.withOpacity(0.3),
              ),
            ),
          ),
          // Notifications List
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            children: const [
              NotificationItem(
                username: 'sarkar15',
                action: 'commented on the question',
                time: '1 minute ago',
              ),
              NotificationDivider(),
              NotificationItem(
                username: 'evanelwoodddd',
                action:
                    'commented on the question you answered: "The sum of the three consecutive int..."',
                time: '12 minutes ago',
              ),
              NotificationDivider(),
              NotificationItem(
                username: 'johndoe',
                action: 'liked your answer',
                time: '45 minutes ago',
              ),
              NotificationDivider(),
              NotificationItem(
                username: 'janedoe',
                action:
                    'commented on the question you answered: "The sum of the three consecutive int..."',
                time: '1 hour ago',
              ),
              NotificationDivider(),
              NotificationItem(
                username: 'techguru',
                action: 'replied to your comment',
                time: '2 hours ago',
              ),
              NotificationDivider(),
              NotificationItem(
                username: 'alex99',
                action: 'shared your post',
                time: '4 hours ago',
              ),
              NotificationDivider(),
              NotificationItem(
                username: 'sammy23',
                action: 'commented "Great work!"',
                time: '5 hours ago',
              ),
              NotificationDivider(),
              NotificationItem(
                username: 'designqueen',
                action:
                    'commented on the question you answered: "The sum of the three consecutive int..."',
                time: '7 hours ago',
              ),
              NotificationDivider(),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Widget for Notifications
class NotificationItem extends StatelessWidget {
  final String username;
  final String action;
  final String time;

  const NotificationItem({
    super.key,
    required this.username,
    required this.action,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        backgroundColor: AppColors().orange,
        radius: 25,
        child: const Icon(Icons.person, color: Colors.white, size: 28),
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
          color: AppColors().white.withOpacity(0.7),
        ),
      ),
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
