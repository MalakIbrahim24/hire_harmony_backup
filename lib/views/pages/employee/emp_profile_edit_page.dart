import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hire_harmony/utils/app_colors.dart';

class EmpProfileEditPage extends StatefulWidget {
  const EmpProfileEditPage({super.key});

  @override
  State<EmpProfileEditPage> createState() => _EmpProfileEditPageState();
}

class _EmpProfileEditPageState extends State<EmpProfileEditPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _imageUrl;
  String? _tempImageUrl;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        setState(() {
          _nameController.text = doc['name'] ?? '';
          _imageUrl = doc['img'] ?? 'https://via.placeholder.com/150';
        });
      }
    } catch (e) {
      debugPrint('Error fetching employee data: $e');
    }
  }

  Future<void> _saveProfileUpdates() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final Map<String, dynamic> updates = {};

        // Check if name is provided and add to updates
        if (_nameController.text.isNotEmpty) {
          updates['name'] = _nameController.text;
        }

        // Check if a new image is selected and upload to Supabase
        if (_tempImageUrl != null) {
          final String? uploadedImageUrl =
              await _uploadImageToSupabase(_tempImageUrl!);
          if (uploadedImageUrl != null) {
            updates['img'] = uploadedImageUrl;
          }
        }

        // Update password if both fields are filled
        if (_passwordController.text.isNotEmpty &&
            _confirmPasswordController.text.isNotEmpty) {
          if (_passwordController.text == _confirmPasswordController.text) {
            await _updatePassword(user.uid, _passwordController.text);
          } else {
            throw Exception("Passwords do not match");
          }
        }

        // Update Firestore with new data
        if (updates.isNotEmpty) {
          await _firestore.collection('users').doc(user.uid).update(updates);
        }

        setState(() {
          _imageUrl = updates['img'] ?? _imageUrl;
        });

        // Success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Profile updated successfully!",
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(
                  fontSize: 15,
                  color: AppColors().white,
                ),
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains("Passwords do not match")
                ? "Passwords do not match. Please try again."
                : "Failed to update profile. Please try again.",
            style: GoogleFonts.montserratAlternates(
              textStyle: TextStyle(
                fontSize: 15,
                color: AppColors().white,
              ),
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updatePassword(String userId, String newPassword) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        print("❌ No authenticated user found.");
        return;
      }

      // 🔹 Update password in Firebase Authentication
      await user.updatePassword(newPassword);
      print("✅ Password updated in Firebase Authentication.");

      // 🔹 Generate a new salt
      final String salt = _generateSalt();

      // 🔹 Hash the new password with the salt
      final String hashedPassword = _hashPassword(newPassword, salt);

      // 🔹 Update Firestore with the hashed password and salt
      await _firestore.collection('users').doc(userId).update({
        'passwordHash': hashedPassword,
        'salt': salt,
      });

      print("✅ Password hashed and stored in Firestore.");
    } catch (e) {
      debugPrint("❌ Error updating password: $e");
      throw Exception("Failed to update password.");
    }
  }

// Generates a secure random salt (Base64 encoded)
  String _generateSalt() {
    final Random random = Random.secure();
    final List<int> saltBytes = List.generate(16, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

// Hashes the password using SHA-256 and a salt
  String _hashPassword(String password, String salt) {
    final List<int> bytes = utf8.encode(salt + password);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String?> _uploadImageToSupabase(String imagePath) async {
    try {
      File imageFile = File(imagePath);

      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

      final String filePath = await supabase.Supabase.instance.client.storage
          .from('serviceImages')
          .upload('profile/$fileName', imageFile);

      String publicUrl = supabase.Supabase.instance.client.storage
          .from('serviceImages')
          .getPublicUrl(filePath.replaceFirst('serviceImages/', ''));

      debugPrint('Uploaded image URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      debugPrint('Supabase upload error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    _tempImageUrl = image.path; // Store local path
                  });
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _tempImageUrl != null
                        ? FileImage(File(_tempImageUrl!))
                        : NetworkImage(
                            _imageUrl ?? 'https://via.placeholder.com/150',
                          ) as ImageProvider,
                  ),
                  const Icon(Icons.edit, color: Colors.white, size: 24),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfileUpdates,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Save Changes",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
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
}
