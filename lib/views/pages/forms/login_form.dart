import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/view_models/cubit/auth_cubit.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();
  final AuthServices authServices = AuthServicesImpl();

  bool _isVisible = false;
  bool isLogin = true;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      debugPrint('Email: $email');
      debugPrint('Password: $password');

      await BlocProvider.of<AuthCubit>(context).signInWithEmailAndPassword(
        email, // Trimmed email
        password, // Trimmed password
      );
    }
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final role = _roleController.text.trim();

      debugPrint('Email: $email');
      debugPrint('Password: $password');
      debugPrint('Role: $role');

      await BlocProvider.of<AuthCubit>(context).signUpWithEmailAndPassword(
        email, // Trimmed email
        password, // Trimmed password
        role, // Trimmed role
      );
    }
  }

  Future<String> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    String deviceDetails = '';

    if (Platform.isAndroid) {
      // For Android devices
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceDetails =
          'Android ${androidInfo.version.release} (${androidInfo.model})';
    } else if (Platform.isIOS) {
      // For iOS devices
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceDetails =
          '${iosInfo.name} (${iosInfo.systemName} ${iosInfo.systemVersion})';
    } else {
      deviceDetails = 'Unknown Device';
    }

    return deviceDetails;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Login to your account',
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
                  'Email',
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
                          alpha: 0.5), // Light gray color with transparency
                      width: 1.0, // Thin border to make it barely visible
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              BlocConsumer<AuthCubit, AuthState>(
                bloc: cubit,
                listenWhen: (previous, current) =>
                    current is AuthSuccess ||
                    current is AuthFailure ||
                    current is AuthCusSuccess ||
                    current is AuthEmpSuccess,
                listener: (context, state) async {
                  if (state is AuthSuccess) {
                    final user = await authServices.currentUser();
                    final device = await getDeviceInfo();
                    FirestoreService.instance.logActivity(
                      uid: user!.uid,
                      action: "Admin logged in",
                      device: device,
                    );
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.adnnavPage);
                  } else if (state is AuthCusSuccess) {
                    final user = await authServices.currentUser();
                    final device = await getDeviceInfo();
                    FirestoreService.instance.logActivity(
                      uid: user!.uid,
                      action: "Customer logged in",
                      device: device,
                    );
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.customButtomNavbarPage);
                  } else if (state is AuthEmpSuccess) {
                    final user = await authServices.currentUser();
                    final device = await getDeviceInfo();
                    FirestoreService.instance.logActivity(
                      uid: user!.uid,
                      action: "Employee logged in",
                      device: device,
                    );
                    if (!context.mounted) return;
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.empNavbar);
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 16,
                            color: AppColors().white,
                          ),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    current is AuthLoading ||
                    current is AuthFailure ||
                    current is AuthInitial ||
                    current is AuthSuccess ||
                    current is AuthEmpSuccess ||
                    current is AuthCusSuccess,
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return MainButton(
                      // Ensure the background color matches
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: AppColors().orange,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        // Add background color for visibility
                      ),
                    );
                  }

                  return const MainButton().copyWith(
                    onPressed: isLogin ? login : register,
                    color: AppColors().white,
                    bgColor: AppColors().orange,
                    text: 'Log In',
                  );
                },
              ),
              const SizedBox(height: 80),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPasswordPage);
                  },
                  child: Text(
                    'Forgot password?',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 15,
                      color: AppColors().navy,
                    ),
                  ),
                ),
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t Have an account? ',
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 18,
                      color: AppColors().navy,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign Up!',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 18,
                          color: AppColors().orange,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.signupChoicePage);
                            // Handle the "Log In" click event here
                            print('Log In clicked!');
                          },
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
