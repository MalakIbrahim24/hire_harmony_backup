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
    // Step 1: Ask for the current password
    String? currentPassword = await _showInputDialog(
      'Verify Password',
      'Enter current password',
      isObscure: true,
    );

    if (currentPassword == null || currentPassword.isEmpty) return;

    // Step 2: Re-authenticate user
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

    // Step 3: Ask for the new password
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

    // Step 4: Check if the new password is the same as the current password
    if (newPassword == currentPassword) {
      Fluttertoast.showToast(
        msg: "New password should be different from the current one",
        textColor: AppColors().white,
        backgroundColor: AppColors().red,
      );
      return;
    }

    // Step 5: Update the password
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().navy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/adminmalak.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: AppColors().grey.withOpacity(0.7)),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Text(
                  'Malak\'s Personal Information',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 20,
                    color: AppColors().white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 100),
                AdnProfileContainer(
                  icon: Icons.email_rounded,
                  title: 'Reset Password',
                  onTap: _updatePassword,
                ),
                AdnProfileContainer(
                  icon: Icons.notifications_active,
                  title: 'Notifications',
                  onTap: () {},
                ),
                AdnProfileContainer(
                  icon: Icons.access_time_outlined,
                  title: 'Activity',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.adnactivityPage);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
