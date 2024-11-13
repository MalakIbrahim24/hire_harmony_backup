import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationSuccessPage extends StatefulWidget {
  final String notificationTitle;
  final String notificationMessage;

  const VerificationSuccessPage({
    super.key,
    required this.notificationTitle,
    required this.notificationMessage,
  });

  @override
  State<VerificationSuccessPage> createState() =>
      _VerificationSuccessPageState();
}

class _VerificationSuccessPageState extends State<VerificationSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: AppColors().white,
        elevation: 0,
        title: Text(
          'Verify',
          style: GoogleFonts.montserratAlternates(
            fontSize: 22,
            color: AppColors().navy,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              // Add close action
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25.0),
          child: Divider(
            thickness: 1,
            color: AppColors().grey,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_outlined,
                        color: AppColors().orange, size: 35),
                    const SizedBox(width: 8),
                    Text(
                      'Hire Harmony',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors().navy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextButton.icon(
                  onPressed: () {
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
                const SizedBox(height: 32),
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
              ],
            ),
          ),
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors().grey,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text(
                  '© 2024, Hire All rights reserved',
                  style: TextStyle(color: AppColors().grey2),
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
