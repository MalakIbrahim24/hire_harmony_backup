import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/forms/signin_form.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      body: SingleChildScrollView(
        child: SafeArea(
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
                    SigninForm(), // Login form
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
