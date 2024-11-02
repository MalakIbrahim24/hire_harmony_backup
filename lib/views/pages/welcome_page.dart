import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double _opacity = 0.0; // For the floating in of icon and title
  double _pageOpacity =
      0.0; // For smoother fade-in of the rest of the page content

  @override
  void initState() {
    super.initState();
    // Start the animation after a short delay for the floating icon and title
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Show the rest of the page with a smoother fade after the text animation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _pageOpacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().navy, // Background dark blue
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Top Section (Logo + Text)
              Column(
                children: [
                  const SizedBox(height: 80), // Padding for top of the screen

                  // Animated icon fade-in
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(seconds: 2),
                    child: const Center(
                      child: Icon(
                        Icons.h_mobiledata,
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Animated text fade-in
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(seconds: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          'Hire Harmony',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 36,
                            color: AppColors().white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 150),

                  // Rest of the content fades in smoothly without floating
                  AnimatedOpacity(
                    opacity: _pageOpacity,
                    duration: const Duration(seconds: 1), // Shorter smooth fade
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'All services on \nyour fingertips.',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 36,
                            color: AppColors().white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Bottom Section (Log In + Sign Up Buttons)
              AnimatedOpacity(
                opacity: _pageOpacity,
                duration:
                    const Duration(seconds: 1), // Smooth fade-in for buttons
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Log In Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.loginPage);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Log In',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 18,
                            color: AppColors().white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 30),

                      // Sign Up Button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.signinPage);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 18,
                            color: AppColors().black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
