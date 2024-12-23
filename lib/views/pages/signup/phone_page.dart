import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/back_icon_button.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhonePage extends StatefulWidget {
  // Add role as a parameter

  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool isSmsSent = false;
  bool isVerifyButtonEnabled = false;
  bool isSendOtpButtonEnabled = false;
  String verificationId = "";

  // Validate phone number format (basic validation)
  bool isValidPhoneNumber(String phoneNumber) {
    // Regex to match the required phone number format
    final phoneRegex =
        RegExp(r'^\+\d{12,15}$'); // Matches + followed by 10-15 digits
    return phoneRegex.hasMatch(phoneNumber);
  }

  // Hash a password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Send OTP
  Future<void> sendOtp() async {
    final String phoneNumber = '+970${_phoneController.text.trim()}';

    if (!isValidPhoneNumber(phoneNumber)) {
      Fluttertoast.showToast(
        msg: "Please enter a valid phone number.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Continue with sending OTP
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number verified!')),
          );
          setState(() {
            if (!mounted) return;
            isVerifyButtonEnabled = true;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verId, int? resendToken) {
          if (!mounted) return;
          setState(() {
            verificationId = verId;
            isSmsSent = true; // Display the OTP input field
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP sent successfully!')),
          );
        },
        codeAutoRetrievalTimeout: (String verId) {
          if (!mounted) return;
          setState(() {
            verificationId = verId;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    }
  }

// Verify OTP and register the user
  Future<void> verifyOtpAndRegister(Map<String, String> formData) async {
    try {
      // Verify the OTP and sign in the user with the phone credential
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _otpController.text,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('User creation failed.');
      }

      final User user = userCredential.user!;

      // Link email/password to the phone-authenticated account
      final emailCredential = EmailAuthProvider.credential(
        email: formData['email']!,
        password: formData['password']!,
      );
      await user.linkWithCredential(emailCredential);

      // Unlink the phone provider to remove the phone number as an identifier
      await user.unlink(PhoneAuthProvider.PROVIDER_ID);

      // Update the user's email (optional but recommended)
      await user.verifyBeforeUpdateEmail(formData['email']!);

      // Update the user's display name
      await user.updateDisplayName(formData['name']);

      // Hash the password before storing in Firestore
      String hashedPassword = _hashPassword(formData['password']!);

      // Store user data in Firestore

      // Navigate based on role
      if (formData['role'] == 'customer') {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': formData['name'],
          'email': formData['email'],
          'passwordHash': hashedPassword, // Store hashed password
          'phone':
              '+970${_phoneController.text.trim()}', // Add the phone number
          'role': formData['role'], // Role (customer or employee)
        });
        // Navigate to customer verification success page
        if (!mounted) return;
        Navigator.pushNamed(context, AppRoutes.cusVerificationSuccessPage);
      } else if (formData['role'] == 'employee') {
        // Navigate to employee-specific signup page
        if (!mounted) return;
        Navigator.pushNamed(context, AppRoutes.empidverificationPage,
            arguments: {
              'uid': user.uid,
              'email': formData['email'],
              'name': formData['name'],
              'phone': '+970${_phoneController.text.trim()}',
            });
      }
    } catch (e) {
      // Show error message if OTP verification fails or any other error occurs
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors().red,
          content: Text(
            'Invalid OTP or Error: $e',
            style: GoogleFonts.montserratAlternates(
              color: AppColors().white,
              fontSize: 15,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve data passed from SignUpPage
    final Map<String, String>? formData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    if (formData == null) {
      return const Center(
        child: Text(
          'Error: No user data provided.',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors().white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Stack(
              children: [
                // Back Button and Title inside a Positioned widget
                Positioned(
                  top: 40,
                  left: 10,
                  child: Row(
                    children: [
                      const BackIconButton(),
                      const SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Verify',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 20,
                            color: AppColors().navy,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Main content inside a Padding widget
                Padding(
                  padding: const EdgeInsets.only(
                      top: 80), // Adjust top padding to avoid overlap
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Phone verification form
                      const SizedBox(height: 65),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Aligns children to the start
                            children: [
                              const SizedBox(
                                  height: 20), // Adds some space at the top
                              Text(
                                'Phone number',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 15,
                                  color: AppColors().navy,
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      20), // Adds spacing between text and TextFormField
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.phone_android_outlined),
                                  prefixText:
                                      '+970 ', // Pre-fills the country code
                                  prefixStyle: TextStyle(
                                      color: AppColors().black, fontSize: 16),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withValues(
                                          alpha: 0.5), // Light gray border
                                      width: 1.0,
                                    ),
                                  ),
                                  hintText: 'Enter your phone number',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // Automatically enable the "Send OTP" button if the input is valid
                                    isSendOtpButtonEnabled = isValidPhoneNumber(
                                        '+970${_phoneController.text.trim()}');
                                  });
                                },
                              ),

                              const SizedBox(height: 60),

                              // OTP Field (visible only after sending OTP)
                              if (isSmsSent)
                                PinCodeTextField(
                                  appContext: context,
                                  controller: _otpController,
                                  length: 6,
                                  onChanged: (value) {
                                    setState(() {
                                      isVerifyButtonEnabled = value.length == 6;
                                    });
                                  },
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.underline,
                                    fieldHeight: 50,
                                    fieldWidth: 40,
                                    inactiveColor: AppColors().grey,
                                    activeColor: AppColors().orange,
                                    selectedColor: AppColors().orange,
                                  ),
                                ),
                              const SizedBox(height: 20),

                              // Send OTP Button
                              MainButton(
                                color: isSendOtpButtonEnabled
                                    ? AppColors().white
                                    : AppColors().grey,
                                text: "Send OTP",
                                bgColor: isSendOtpButtonEnabled
                                    ? AppColors().orange
                                    : AppColors().greylight,
                                onPressed:
                                    isSendOtpButtonEnabled ? sendOtp : null,
                              ),
                              const SizedBox(height: 20),

                              // Verify Button
                              MainButton(
                                color: isVerifyButtonEnabled
                                    ? AppColors().white
                                    : AppColors().grey,
                                text: "Verify",
                                bgColor: isVerifyButtonEnabled
                                    ? AppColors().orange
                                    : AppColors().greylight,
                                onPressed: isVerifyButtonEnabled
                                    ? () => verifyOtpAndRegister(formData)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
