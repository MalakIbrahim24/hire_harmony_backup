import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';

class SigninForm extends StatelessWidget {
  const SigninForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sign Up',
                style: GoogleFonts.montserratAlternates(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors().navy,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'E-mail',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 15,
                  color: AppColors().navy,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                // No border when not focused
                border: InputBorder.none,
                // Light gray border when focused
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(
                        0.5), // Light gray color with some transparency
                    width: 1.0, // Make the border barely visible
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Password',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 15,
                  color: AppColors().navy,
                ),
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: const Icon(Icons.visibility),
                // No border when not focused
                border: InputBorder.none,
                // Light gray border when focused
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey
                        .withOpacity(0.5), // Light gray color with transparency
                    width: 1.0, // Thin border to make it barely visible
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Confirm password',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 15,
                  color: AppColors().navy,
                ),
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_person),
                suffixIcon: const Icon(Icons.visibility),

                // No border when not focused
                border: InputBorder.none,
                // Light gray border when focused
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey
                        .withOpacity(0.5), // Light gray color with transparency
                    width: 1.0, // Thin border to make it barely visible
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Phone number',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 15,
                  color: AppColors().navy,
                ),
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone),

                // No border when not focused
                border: InputBorder.none,
                // Light gray border when focused
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey
                        .withOpacity(0.5), // Light gray color with transparency
                    width: 1.0, // Thin border to make it barely visible
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Login button

            const MainButton().copyWith(
              color: AppColors().white,
              text: "Next",
              bgColor: AppColors().orange,
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.phonePage),
            ),

            const SizedBox(height: 80),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/log-in-page',
                    (Route<dynamic> route) =>
                        route.settings.name == '/welcome-page',
                  );
                },
                child: Text(
                  'Have an account? Log In!',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    color: AppColors().navy,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
