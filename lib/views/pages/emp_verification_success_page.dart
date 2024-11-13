import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';

class EmpVerificationSuccessPage extends StatefulWidget {
  final String notificationTitle;
  final String notificationMessage;

  const EmpVerificationSuccessPage({
    super.key,
    required this.notificationTitle,
    required this.notificationMessage,
  });

  @override
  State<EmpVerificationSuccessPage> createState() =>
      _VerificationSuccessPageState();
}

class _VerificationSuccessPageState extends State<EmpVerificationSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors().white,
      body: Column(
        children: [
          /*
          PreferredSize(
            preferredSize: const Size.fromHeight(25.0),
            child: Divider(
              thickness: 1,
              color: AppColors().grey,
            ),
          ),
          */
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_outlined,
                        color: AppColors().orange, size: 40),
                    const SizedBox(width: 8),
                    Text(
                      'Hire Harmony',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors().navy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.loginPage, // The route to navigate to
                      (route) =>
                          route.settings.name ==
                          AppRoutes
                              .welcomePage, // Condition to stop removing when the welcome page is found
                    );

                    // Navigation logic
                  },
                  icon: Icon(Icons.arrow_back, color: AppColors().grey),
                  label: Text(
                    'Back to login',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 13,
                      color: AppColors().grey2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Icon(Icons.check_circle, color: AppColors().orange, size: 70),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notificationTitle, // Access widget properties
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors().navy,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.notificationMessage, // Access widget properties
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 15,
                        color: AppColors().grey2,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 100,
                ),
                MainButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.loginPage,
                      (Route<dynamic> route) =>
                          route.settings.name == AppRoutes.welcomePage,
                    );
                  },
                  text: 'Back to Login page',
                ),
              ],
            ),
          ),
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors().orange.withOpacity(0.3),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text(
                  '© 2024, Hire All rights reserved',
                  style: TextStyle(color: AppColors().navy),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
