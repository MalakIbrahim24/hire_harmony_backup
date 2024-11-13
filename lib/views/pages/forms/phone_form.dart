import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({super.key});

  @override
  State<PhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final FirestoreService _fireS = FirestoreService.instance;
  final AuthServices authServices = AuthServicesImpl();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Verify',
                  style: GoogleFonts.montserratAlternates(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors().navy,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Enter your phone number to get an OTP',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    color: AppColors().grey,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login button

              const SizedBox(height: 10),
              PinCodeTextField(
                appContext: context,
                length: 4, // Change this depending on the OTP length
                onChanged: (value) {},
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,
                  fieldHeight: 50,
                  fieldWidth: 40,
                  inactiveColor: Colors.grey,
                  activeColor: AppColors().orange,
                  selectedColor: AppColors().orange,
                ),
              ),
            ],
            // PIN code field with dashes
          ),
          const SizedBox(
            height: 200,
          ),
          const MainButton().copyWith(
              color: AppColors().white,
              fontWeight: FontWeight.w500,
              bgColor: AppColors().orange,
              text: 'Next',
              onPressed: () async {
                final user = await authServices.currentUser();

                if (user != null) {
                  String role = await _fireS.getUserRoleByUid(user.uid);
                  if (role == 'customer') {
                    Navigator.pushNamed(
                        // ignore: use_build_context_synchronously
                        context,
                        AppRoutes.cusVerificationSuccessPage);
                  } else if (role == 'employee') {
                    Navigator.pushNamed(
                        // ignore: use_build_context_synchronously
                        context,
                        AppRoutes.empVerificationSuccessPage);
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(
                      // ignore: use_build_context_synchronously
                      context, AppRoutes.cusVerificationSuccessPage);
                }
              }),
        ],
      ),
    );
  }
}
