import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AdnProfileInfoPage extends StatefulWidget {
  const AdnProfileInfoPage({super.key});

  @override
  State<AdnProfileInfoPage> createState() => _AdnProfileInfoPageState();
}

class _AdnProfileInfoPageState extends State<AdnProfileInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors().white, // Set your desired background color here
        child: Stack(
          children: [
            // Positioned back button inside Stack
            Positioned(
              top: 40, // Adjust the top position as needed
              left: 10, // Adjust the left position as needed
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
            // Main content inside a Padding widget
            const Padding(
              padding: EdgeInsets.only(
                  top: 80), // Adjust top padding to avoid overlap
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top section with logo and title
                  SizedBox(height: 28),
                  // Login form or other content
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
