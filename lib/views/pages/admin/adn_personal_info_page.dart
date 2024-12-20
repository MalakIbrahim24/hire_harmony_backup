import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/admin/adn_profile_container.dart';

class AdnPersonalInfoPage extends StatefulWidget {
  const AdnPersonalInfoPage({super.key});

  @override
  State<AdnPersonalInfoPage> createState() => _AdnPersonalInfoPageState();
}

class _AdnPersonalInfoPageState extends State<AdnPersonalInfoPage> {
  final FirestoreService _firestoreService = FirestoreService.instance;

  Future<void> _updatePassword() async {
    String? currentPassword = await _showInputDialog(
      'Verify Password',
      'Enter current password',
      isObscure: true,
    );

    if (currentPassword == null || currentPassword.isEmpty) return;

    bool isAuthenticated =
        await _firestoreService.reauthenticateUser(currentPassword);
    if (!isAuthenticated) {
      Fluttertoast.showToast(
        msg: "Incorrect current password",
        textColor: AppColors().white,
        backgroundColor: AppColors().red,
      );
      return;
    }

    String? newPassword = await _showInputDialog(
      'Change Password',
      'Enter new password',
      isObscure: true,
    );

    if (newPassword == null || newPassword.isEmpty || newPassword.length < 6) {
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters long",
        backgroundColor: AppColors().navy,
        textColor: AppColors().white,
      );
      return;
    }

    if (newPassword == currentPassword) {
      Fluttertoast.showToast(
        msg: "New password should be different from the current one",
        textColor: AppColors().white,
        backgroundColor: AppColors().red,
      );
      return;
    }

    await _firestoreService.updatePassword(newPassword);
    Fluttertoast.showToast(
      msg: "Password updated successfully",
      textColor: AppColors().white,
      backgroundColor: AppColors().orange,
    );
  }

  Future<String?> _showInputDialog(String title, String hint,
      {bool isObscure = false}) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          obscureText: isObscure,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/adminmalak.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors().black.withValues(alpha: 0.5),
                      AppColors().black.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
              child: Container(
                color: AppColors().navy.withValues(alpha: 0.3),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Profile Header with Circle Avatar
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 100,
                  backgroundImage:
                      AssetImage('lib/assets/images/adminmalak.jpeg'),
                ),
                const SizedBox(height: 30),
                Text(
                  'Malak\'s Personal Information',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors().white,
                  ),
                ),
                const SizedBox(height: 60),

                // Information Cards
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      children: [
                        AdnProfileContainer(
                          title: 'Reset Password',
                          icon: Icons.lock_reset,
                          onTap: _updatePassword,
                        ),
                        const SizedBox(height: 50),
                        AdnProfileContainer(
                          title: 'View Activity',
                          icon: Icons.access_time_outlined,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.adnactivityPage);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
