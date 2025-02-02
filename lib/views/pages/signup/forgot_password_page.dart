import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? oldAuthPassword;
  String? oldPassword; // Store old password before reset
  String? oldSalt;

// Store the old authentication password

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String email = _emailController.text.trim();

      // 🔹 Fetch UID from Firestore
      String? userId = await getUserIdByEmail(email);
      if (userId == null) {
        showError("No user found with this email.");
        return;
      }

      // 🔹 Send password reset email
      await _auth.sendPasswordResetEmail(email: email);
      showSuccess(
          "Password reset email sent! Reset and return here to continue.");

      // 🔹 Prompt user to enter the **new password**
      String? newPassword = await _promptNewPassword();
      if (newPassword == null || newPassword.isEmpty) {
        showError("Password reset process canceled.");
        return;
      }

      // 🔹 Hash and store new password immediately
      await updatePasswordInFirestore(userId, newPassword);
      showSuccess("Password updated securely.");
    } on FirebaseAuthException catch (e) {
      showError(e.message ?? "An error occurred");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> getUserIdByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        print("❌ No user found with email: $email");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching user by email: $e");
      return null;
    }
  }

  Future<void> updatePasswordInFirestore(
      String userId, String newPassword) async {
    final DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(userId);

    print("ℹ️ Updating password for user: users/$userId");

    DocumentSnapshot userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      print("❌ User document not found in Firestore.");
      return;
    }

    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

    // 🔹 If the user already has a salt, use it; otherwise, generate a new one
    String salt =
        userData.containsKey('salt') ? userData['salt'] : generateSalt();

    print("🔹 Using salt: $salt");

    // 🔹 Hash the new password with the salt
    String newPasswordHash = hashPassword(newPassword, salt);
    print("🔹 New password hash: $newPasswordHash");

    try {
      await userDoc.set({
        'passwordHash': newPasswordHash,
        'salt': salt,
      }, SetOptions(merge: true));

      print("✅ Firestore updated successfully!");
      showSuccess("Password updated successfully.");
    } catch (e) {
      print("❌ Firestore update failed: $e");
      showError("Failed to update password.");
    }
  }

  Future<String?> _promptNewPassword() async {
    TextEditingController passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter New Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ensure this is the same password you set via email reset.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, passwordController.text.trim());
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  String generateSalt() {
    final Random random = Random.secure();
    final List<int> saltBytes = List.generate(16, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  String hashPassword(String password, String salt) {
    var bytes = utf8.encode(salt + password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.montserratAlternates(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.montserratAlternates(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reset Password',
          style: GoogleFonts.montserratAlternates(
            fontSize: 20,
            color: AppColors().navy,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your email to receive a password reset link:',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserratAlternates(
                fontSize: 18,
                color: AppColors().grey,
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Email: ',
                labelStyle: GoogleFonts.montserratAlternates(
                  fontSize: 15,
                  color: AppColors().grey,
                ),
                hintText: 'Enter your email',
                hintStyle: GoogleFonts.montserratAlternates(
                  fontSize: 15,
                  color: AppColors().grey,
                ),
              ),
            ),
            const SizedBox(height: 50),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(AppColors().orange),
                    ),
                    onPressed: () {
                      if (_emailController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please enter an email address.',
                              style: GoogleFonts.montserratAlternates(
                                fontSize: 15,
                                color: AppColors().navy,
                              ),
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }
                      _resetPassword();
                    },
                    child: Text(
                      'Send Reset Link',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 16,
                        color: AppColors().white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
