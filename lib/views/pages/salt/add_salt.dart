import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateAllUsers {
  /// 🔑 Generate a unique secret key for HMAC (32 bytes)
  String generateSecretKey() {
    final Random random = Random.secure();
    final List<int> keyBytes = List.generate(32, (_) => random.nextInt(256));
    return base64Encode(keyBytes);
  }

  /// 🔐 Generate HMAC using SHA-256 and a secret key
  String generateHmac(String passwordHash, String secretKey) {
    var key = utf8.encode(secretKey);
    var bytes = utf8.encode(passwordHash);
    var hmac = Hmac(sha256, key);
    var digest = hmac.convert(bytes);
    return digest.toString();
  }

}

class AddSalt {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔑 Generate a random 16-byte salt
  String generateSalt() {
    final Random random = Random.secure();
    final List<int> saltBytes = List.generate(16, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  /// 🔐 Hash password using SHA-256 with a given salt
  String hashPassword(String password, String salt) {
    var bytes = utf8.encode(salt + password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 🛠 Validate the password (must be at least 8 characters with a mix of letters and numbers)
  bool isValidPassword(String password) {
    return password.length >= 8 &&
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
  }

  /// 🔄 Update password securely
  Future<void> updatePassword(BuildContext context) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "⚠️ User not logged in!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    final String userUid = currentUser.uid;

    // Fetch stored password hash & salt from Firestore
    final DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(userUid).get();

    if (!userSnapshot.exists) {
      Fluttertoast.showToast(
        msg: "⚠️ User not found!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    final Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;
    final String storedPasswordHash = userData['passwordHash'] ?? '';
    final String storedSalt = userData['salt'] ?? '';
    final String email = userData['email'] ?? '';

    // UI for password update
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    if (!context.mounted) return;
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("🔑 Update Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPasswordField(
                  "Current Password", currentPasswordController),
              _buildPasswordField("New Password", newPasswordController),
              _buildPasswordField(
                  "Confirm New Password", confirmPasswordController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Update"),
            ),
          ],
        );
      },
    );

    if (confirmed == null || !confirmed) {
      Fluttertoast.showToast(
        msg: "❌ Password update canceled",
        textColor: Colors.white,
        backgroundColor: Colors.orange,
      );
      return;
    }

    String currentPassword = currentPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Validations
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: "⚠️ All fields are required!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (!isValidPassword(newPassword)) {
      Fluttertoast.showToast(
        msg:
            "⚠️ New password must be at least 8 characters long and contain letters and numbers.",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Fluttertoast.showToast(
        msg: "⚠️ New passwords do not match!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    // Verify current password
    final String enteredPasswordHash =
        hashPassword(currentPassword, storedSalt);
    if (enteredPasswordHash != storedPasswordHash) {
      Fluttertoast.showToast(
        msg: "❌ Incorrect current password!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      // Step 1: Reauthenticate user
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      await currentUser.reauthenticateWithCredential(credential);

      // Step 2: Update password in Firebase Authentication
      await currentUser.updatePassword(newPassword);

      // Step 3: Generate a new salt & hash the new password
      String newSalt = generateSalt();
      final String hashedNewPassword = hashPassword(newPassword, newSalt);

      // Step 4: Store new salt and hashed password in Firestore
      await _firestore.collection('users').doc(userUid).update({
        'passwordHash': hashedNewPassword,
        'salt': newSalt,
      });

      Fluttertoast.showToast(
        msg: "✅ Password updated successfully!",
        textColor: Colors.white,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "⚠️ Error updating password: $e",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  /// 📌 Custom Password Field Builder
  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
