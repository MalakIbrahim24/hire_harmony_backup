import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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

  bool _isVisible = false;
  bool isLogin = true;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Email: ${_passwordController.text}');
      await BlocProvider.of<AuthCubit>(context).signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);

      // _emailController.text is used  to get the email from the text field
    }
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      // _emailController.text is used  to get the email from the text field
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Email: ${_passwordController.text}');
      await BlocProvider.of<AuthCubit>(context).signUpWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          _roleController.text);
    }
  }

  String? validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);

    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return 'Password must be at least 8 characters long and must contain at least one uppercase letter';
    }
  }

  String? validateUserName(String value) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);

    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return 'Please enter a valid User name';
    }
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
                  'User name',
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
                      color: Colors.grey.withOpacity(
                          0.5), // Light gray color with some transparency
                      width: 1.0, // Make the border barely visible
                    ),
                  ),
                ),
                validator: (value) => validateUserName(value!),
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
                        color: Colors.grey.withOpacity(
                            0.5), // Light gray color with transparency
                        width: 1.0, // Thin border to make it barely visible
                      ),
                    ),
                  ),
                  validator: (value) => validatePassword(value!)),
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
                    Navigator.pushNamed(context, AppRoutes.adnnavPage);
                  } else if (state is AuthCusSuccess) {
                    Navigator.pushNamed(context, AppRoutes.cushomePage);
                  } else if (state is AuthEmpSuccess) {
                    Navigator.pushNamed(context, AppRoutes.emphomePage);
                  } else if (state is AuthFailure) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: const Text('Error'),
                            content: Text(state.message),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ]);
                      },
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
                  onPressed: () {},
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
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.signinPage);
                  },
                  child: Text(
                    'Already have an account? Sign Up!',
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
      ),
    );
  }
}
