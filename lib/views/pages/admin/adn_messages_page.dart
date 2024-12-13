import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/admin/chat_details_page.dart';

class AdnMessagesPage extends StatefulWidget {
  const AdnMessagesPage({super.key});

  @override
  State<AdnMessagesPage> createState() => _AdnMessagesPageState();
}

class _AdnMessagesPageState extends State<AdnMessagesPage> {
  final List<Map<String, String>> chats = [
    {'name': 'John Doe', 'lastMessage': 'Hey, how are you?', 'time': '2:30 PM'},
    {
      'name': 'Jane Smith',
      'lastMessage': 'I need help with my account.',
      'time': '1:15 PM'
    },
    {
      'name': 'Alex Johnson',
      'lastMessage': 'Sure, I will send it soon!',
      'time': 'Yesterday'
    },
    {
      'name': 'Tech Support',
      'lastMessage': 'Your issue has been resolved.',
      'time': '2 days ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      body: Stack(
        children: [
          // Background Image
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
                color: AppColors().navy.withValues(alpha: 0.3),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 50),
            child: SafeArea(
              child: Column(
                children: [
                  // AppBar Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors().white,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        "Messages",
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 22,
                          color: AppColors().white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 50), // Spacing for alignment
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Chat List
                  Expanded(
                    child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to Chat Details Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailsPage(
                                  chatName: chat['name']!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors().white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors().orange,
                                  radius: 30,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chat['name']!,
                                        style: GoogleFonts.montserratAlternates(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors().navy,
                                        ),
                                      ),
                                      Text(
                                        chat['lastMessage']!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserratAlternates(
                                          fontSize: 14,
                                          color: AppColors()
                                              .navy
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  chat['time']!,
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 12,
                                    color: AppColors().grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
