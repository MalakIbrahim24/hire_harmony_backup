import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';

class CusVerificationSuccessPage extends StatefulWidget {
  final String notificationTitle;
  final String notificationMessage;

  const CusVerificationSuccessPage({
    super.key,
    required this.notificationTitle,
    required this.notificationMessage,
  });

  @override
  State<CusVerificationSuccessPage> createState() =>
      _VerificationSuccessPageState();
}

class _VerificationSuccessPageState extends State<CusVerificationSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const SizedBox(
            height: 170,
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
                        color: AppColors().orange, size: 50),
                    const SizedBox(width: 8),
                    Text(
                      'Hire Harmony',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Icon(Icons.check_circle, color: AppColors().orange, size: 70),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.notificationTitle, // Access widget properties
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
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
                  height: 150,
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
                  text: 'Proceed to Login page',
                ),
              ],
            ),
          ),
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors().babyBlue.withValues(alpha: 0.3),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text(
                  '© 2024, Hire All rights reserved',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
