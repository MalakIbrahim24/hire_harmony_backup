import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/admin/adn_profile_container.dart';

class AdnPersonalInfoPage extends StatefulWidget {
  const AdnPersonalInfoPage({super.key});

  @override
  State<AdnPersonalInfoPage> createState() => _AdnProfileInfoPageState();
}

class _AdnProfileInfoPageState extends State<AdnPersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors().white,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: AppColors().navy,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/adminmalak.jpeg'),
                fit: BoxFit.cover, // covers the entire screen
              ),
            ),
          ),
          Container(
            color: AppColors().grey.withOpacity(0.7),
          ),
          // Positioned back button inside Stack

          // Main content inside a Padding widget
          Padding(
            padding: const EdgeInsets.only(
                top: 80), // Adjust top padding to avoid overlap
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Malak\'s personal information',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 20,
                        color: AppColors().white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Technical support',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 20,
                        color: AppColors().white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Top section with logo and title
                const SizedBox(height: 180),
                AdnProfileContainer(
                  icon: Icons.email_rounded,
                  title: 'Change email',
                  onTap: () {},
                ),
                AdnProfileContainer(
                  icon: Icons.notification_important,
                  title: 'Notifications',
                  onTap: () {},
                ),
                AdnProfileContainer(
                  icon: Icons.phone_android,
                  title: 'Change phone number',
                  onTap: () {},
                ),
                AdnProfileContainer(
                  icon: Icons.access_time,
                  title: 'Activity',
                  onTap: () {},
                ),
                // Login form or other content
              ],
            ),
          ),
        ],
      ),
    );
  }
}
