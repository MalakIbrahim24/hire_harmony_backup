import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmpPhoneForm extends StatefulWidget {
  const EmpPhoneForm({super.key});

  @override
  State<EmpPhoneForm> createState() => _PhoneFormState();
}

class _PhoneFormState extends State<EmpPhoneForm> {
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
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Enter your phone number to get an OTP',
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    color: AppColors().grey2,
                  ),
                ),
              ),

              // Login button

              const SizedBox(height: 70),
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
            height: 170,
          ),
          const MainButton().copyWith(
              color: AppColors().white,
              fontWeight: FontWeight.w500,
              bgColor: AppColors().orange,
              text: 'Next',
              onPressed: () async {
                Navigator.pushNamed(context, AppRoutes.empidverificationPage);
              }),
        ],
      ),
    );
  }
}
