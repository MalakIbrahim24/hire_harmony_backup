import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/admin/adn_profile_container.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: AppColors().white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'lib/assets/images/logo_navy.PNG',
            fit: BoxFit.cover,
          ),
        ),
        // Blur Filter
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: AppColors().navy.withValues(alpha: 0.3),
            ),
          ),
        ),
        SafeArea(
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              'Settings and privacy',
              style: GoogleFonts.montserratAlternates(
                fontSize: 24,
                color: AppColors().white,
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            const SizedBox(
              height: 50,
            ),
            AdnProfileContainer(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Container(
                        decoration: const BoxDecoration(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                'Terms and Conditions',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 28,
                                  color: AppColors().navy,
                                ),
                              ),
                              Text(
                                '1. Commitment to Privacy: We are dedicated to safeguarding your personal information while providing a seamless platform for reserving and managing services.\n2. Purpose of the App: Our app connects customers with freelancers and self-employed professionals, streamlining communication and transaction processes to enhance efficiency and trust.\n3. Customer Features:\n- Customers can view detailed profiles of service providers, including ratings, comments, and any complaints, ensuring transparency and informed decision-making.\n- Advanced search and filtering options help customers find the most suitable service providers quickly and efficiently based on specific criteria.\n4. Employee Verification:\n- Employees are required to provide important personal information, including ID verification and face recognition, to ensure trust and security on the platform.\n- These measures are implemented in strict compliance with privacy laws and regulations.\n',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                  color: AppColors().navy,
                                ),
                              ),
                              Text(
                                '5. Data Security:\n- All personal data collected is protected using industry-standard security protocols to prevent unauthorized access, misuse, or breaches.\n- Sensitive information, such as verification documents and biometric data, is handled securely and only for verification purposes.\n6. Location-Based Services:\n- The app uses advanced AI algorithms to locate the closest service providers based on the customer’s location, eliminating geographic constraints and ensuring timely service delivery.\n7. Transparency and Trust:\n- By maintaining detailed provider profiles and requiring verification, we aim to foster a trustworthy environment for all users.\n- Customers and providers can rate and review each other to maintain high service standards and accountability.\n8. Compliance with Regulations: All data collection and processing are conducted in accordance with applicable privacy regulations to ensure user rights are protected.\n9. Support and Contact: If you have questions, concerns, or require assistance regarding your privacy or the app’s features, please contact us through the app’s support section.\n10. Continuous Improvement: We are constantly working to enhance our platform and its features while maintaining the highest standards of privacy and security.\nThis format ensures that each point starts on a new line when displayed in your app. Let me know if you need further refinements!',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                  color: AppColors().navy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 40,
            ),
            AdnProfileContainer(
              icon: Icons.delete_sweep_outlined,
              title: 'Deleted Accounts',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.deletedAccounts);
              },
            ),
            const SizedBox(
              height: 40,
            ),
            AdnProfileContainer(
              icon: Icons.home_repair_service_outlined,
              title: 'Deleted Services',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.editedServicesPage);
              },
            ),
            const SizedBox(
              height: 50,
            ),
          ]),
        ),
      ]),
    );
  }
}
