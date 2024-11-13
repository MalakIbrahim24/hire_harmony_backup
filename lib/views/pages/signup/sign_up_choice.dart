import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/sign_up_widget.dart';

class SignUpChoice extends StatelessWidget {
  const SignUpChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
                color: AppColors().orange,
                borderRadius: BorderRadius.circular(35)),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors().white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: Text(
          textAlign: TextAlign.left,
          'Register a new account',
          style: GoogleFonts.montserratAlternates(
            fontSize: 15,
            color: AppColors().grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Placeholder for the logo
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors().navy,
                    child: Icon(Icons.handyman_outlined,
                        color: AppColors().white, size: 50),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hire Harmony',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 20,
                      color: AppColors().navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                Text(
                  'Please choose your role',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 15,
                    color: AppColors().navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SignUpWidget(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.signinPage);
                  },
                  userType: 'Customer',
                  description:
                      'Finding a helper here has never been easier than before!',
                  image: Image.asset('lib/assets/images/customer.png'),
                ),
                const SizedBox(height: 15),
                SignUpWidget(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.signinPage);
                  },
                  userType: 'EMPLOYEE',
                  description:
                      'Let’s recruit you faster here.\n Share your experience!',
                  image: Image.asset('lib/assets/images/employee.png'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
