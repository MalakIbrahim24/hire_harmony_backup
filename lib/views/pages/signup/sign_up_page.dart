import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late String role;
  bool _isVisible = false;
  bool _isVisible2 = false;

  final AuthServices authServices = AuthServicesImpl();

  String? validateUserName(String value) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);

    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return 'Please enter a valid email';
    }
  }

  String? validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);

    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return 'Password must be at least 8 characters long\nand contain at least one uppercase letter, one number,\nand one special character.';
    }
  }

  Future<bool> isNameUnique(String name) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users') // Adjust to match your Firestore collection
        .where('name', isEqualTo: name)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  Future<void> registerUser(
      String name, String email, String rawPassword, String role) async {
    final PasswordEncryptionService encryptionService =
        PasswordEncryptionService();
    final encryptedPassword = encryptionService.encryptPassword(rawPassword);

    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'name': name,
      'email': email,
      'password': encryptedPassword, // Store encrypted password
      'role': role,
    });
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly!')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    try {
      await registerUser(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        role,
      );
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.phonePage, arguments: {
        'name': _nameController.text,
        'email': _emailController.text,
        'role': role,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during registration: $e')),
      );
    }
  }

// 128-bit IV
  @override
  Widget build(BuildContext context) {
    // Retrieve the role passed from SignUpChoice
    final Map<String, String>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final String role =
        arguments?['role'] ?? 'customer'; // Default to 'customer'

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
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors().orange),
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
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.montserratAlternates(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: AppColors().navy,
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
                    // Top section with logo and title
                    const SizedBox(height: 28),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  'Name',
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 15,
                                    color: AppColors().navy,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  // No border when not focused
                                  border: InputBorder.none,
                                  // Light gray border when focused
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withValues(
                                          alpha:
                                              0.5), // Light gray color with some transparency
                                      width:
                                          1.0, // Make the border barely visible
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  'E-mail',
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 15,
                                    color: AppColors().navy,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  // No border when not focused
                                  border: InputBorder.none,
                                  // Light gray border when focused
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withValues(
                                          alpha:
                                              0.5), // Light gray color with some transparency
                                      width:
                                          1.0, // Make the border barely visible
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    validateUserName(value ?? ''),
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  'Password',
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 15,
                                    color: AppColors().navy,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isVisible,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isVisible = !_isVisible;
                                      });
                                    },
                                    icon: Icon(_isVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined),
                                  ),
                                  // No border when not focused
                                  border: InputBorder.none,
                                  // Light gray border when focused
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withValues(
                                          alpha:
                                              0.5), // Light gray color with transparency
                                      width:
                                          1.0, // Thin border to make it barely visible
                                    ),
                                  ),
                                ),
                                validator: (value) =>
                                    validatePassword(value ?? ''),
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  'Confirm Password',
                                  style: GoogleFonts.montserratAlternates(
                                    fontSize: 15,
                                    color: AppColors().navy,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !_isVisible2,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isVisible2 = !_isVisible2;
                                      });
                                    },
                                    icon: Icon(_isVisible2
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined),
                                  ),
                                  // No border when not focused
                                  border: InputBorder.none,
                                  // Light gray border when focused
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withValues(
                                          alpha:
                                              0.5), // Light gray color with transparency
                                      width:
                                          1.0, // Thin border to make it barely visible
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 80),
                              MainButton(
                                text: "Next",
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (role == 'employee') {
                                      // Navigate to EmpIdVerificationPage for employees
                                      print('Name: ${_nameController.text}');
                                      print('Email: ${_emailController.text}');
                                      print(
                                          'Password: ${_passwordController.text}');

                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes
                                            .empidverificationPage, // Replace with your actual route name
                                        arguments: {
                                          'name': _nameController.text,
                                          'email': _emailController.text,
                                          'password': _passwordController.text,
                                          'role' : role,
                                        },
                                      );

                                      print(
                                          'Navigating to EmpIdVerificationPage with arguments: ${{
                                        'name': _nameController.text,
                                        'email': _emailController.text,
                                        'password': _passwordController.text,
                                        'role': role,
                                      }}');
                                    } else {
                                      // Navigate to PhonePage for customers
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.phonePage,
                                        arguments: {
                                          'name': _nameController.text,
                                          'email': _emailController.text,
                                          'password': _passwordController.text,
                                          'role': role,
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
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
    );
  }
}

class PasswordEncryptionService {
  final encrypt.Key _key = encrypt.Key.fromLength(32); // 256-bit key
  final encrypt.IV _iv = encrypt.IV.fromLength(16); // 128-bit IV

  String encryptPassword(String password) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(password, iv: _iv);
    return encrypted.base64;
  }

  String decryptPassword(String encryptedPassword) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter
        .decrypt(encrypt.Encrypted.fromBase64(encryptedPassword), iv: _iv);
    return decrypted;
  }
}
