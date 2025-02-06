import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSalt {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a random salt
  String generateSalt() {
    final Random random = Random.secure();
    final List<int> saltBytes =
        List.generate(16, (_) => random.nextInt(256)); // 16-byte salt
    return base64Encode(saltBytes);
  }

  // Hash password with salt
  String hashPassword(String password, String salt) {
    var bytes = utf8.encode(salt + password); // Append salt before hashing
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> updatePassword(BuildContext context) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "User not logged in!",
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
        msg: "user not found!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    final Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>;
    final String storedPasswordHash = userData['passwordHash'] ?? '';
    final String storedSalt = userData['salt'] ?? ''; // Retrieve salt
    final String email = userData['email'] ?? '';

    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    bool? confirmed = await showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Current Password"),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: "Confirm New Password"),
              ),
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
        msg: "Password update canceled",
        textColor: Colors.white,
        backgroundColor: Colors.orange,
      );
      return;
    }

    String currentPassword = currentPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: "All fields are required!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    // Verify current password with stored salt
    final String enteredPasswordHash =
        hashPassword(currentPassword, storedSalt);
    debugPrint("Salt being used: '$storedSalt'");
    debugPrint(currentPassword);
    debugPrint(enteredPasswordHash);
    debugPrint(storedPasswordHash);

    if (enteredPasswordHash != storedPasswordHash) {
      Fluttertoast.showToast(
        msg: "Incorrect current password!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    // Check if new passwords match
    if (newPassword != confirmPassword) {
      Fluttertoast.showToast(
        msg: "New passwords do not match!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      // Step 1: Reauthenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await currentUser.reauthenticateWithCredential(credential);

      // Step 2: Update password in Firebase Authentication
      await currentUser.updatePassword(newPassword);

      // Step 3: Generate a new salt & hash the new password
      String newSalt = generateSalt();
      final String hashedNewPassword = hashPassword(newPassword, newSalt);

      // Step 4: Store new salt and hashed password in Firestore
      await _firestore.collection('users').doc(userUid).update({
        'passwordHash': hashedNewPassword,
        'salt': newSalt, // Store the new salt
      });

      Fluttertoast.showToast(
        msg: "Password updated successfully!",
        textColor: Colors.white,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error updating password: $e",
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
}
