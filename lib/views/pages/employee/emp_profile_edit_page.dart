import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/employee_services.dart';
import 'package:hire_harmony/views/pages/salt/add_salt.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hire_harmony/utils/app_colors.dart';

class EmpProfileEditPage extends StatefulWidget {
  const EmpProfileEditPage({super.key});

  @override
  State<EmpProfileEditPage> createState() => _EmpProfileEditPageState();
}

class _EmpProfileEditPageState extends State<EmpProfileEditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _imageUrl;
  String? _tempImageUrl;

  // final EmployeeService _employeeService = EmployeeService();

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    final data = await EmployeeService.instance.fetchEmployeeData();
    setState(() {
      _nameController.text = data['name'] ?? '';
      _imageUrl = data['img'] ?? '';
    });
  }

  void _saveProfileUpdates() async {
    try {
      final AddSalt addSalt = AddSalt();

      // Check if the password fields are filled for updating the password
      if (_passwordController.text.isNotEmpty ||
          _confirmPasswordController.text.isNotEmpty) {
        if (_passwordController.text == _confirmPasswordController.text) {
          // Use AddSalt to update the password
          await addSalt.updatePassword(context);
        } else {
          throw Exception("Passwords do not match");
        }
      }

      // Call EmployeeService to update other profile information
      await EmployeeService.instance.saveProfileUpdates(
        name: _nameController.text,
        imagePath: _tempImageUrl,
      );

      setState(() {
        _imageUrl = _tempImageUrl ?? _imageUrl;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
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
                            _imageUrl ?? '',
                          ) as ImageProvider,
                  ),
                  const Icon(Icons.edit, color: Colors.white, size: 24),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            MainButton(
              color: AppColors().white,
              text: "Reset Password",
              bgColor: AppColors().orange,
              onPressed: () async {
                print("🔥 Reset Password button pressed!");
                await AddSalt().updatePassword(context);
              },
            ),
            // TextFormField(
            //   controller: _passwordController,
            //   obscureText: !_isPasswordVisible,
            //   style: TextStyle(color: Theme.of(context).colorScheme.primary),
            //   decoration: InputDecoration(
            //     labelText: "New Password",
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     suffixIcon: IconButton(
            //       icon: Icon(
            //         _isPasswordVisible
            //             ? Icons.visibility
            //             : Icons.visibility_off,
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           _isPasswordVisible = !_isPasswordVisible;
            //         });
            //       },
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            // TextFormField(
            //   controller: _confirmPasswordController,
            //   obscureText: !_isConfirmPasswordVisible,
            //   style: TextStyle(color: Theme.of(context).colorScheme.primary),
            //   decoration: InputDecoration(
            //     labelText: "Confirm Password",
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     suffixIcon: IconButton(
            //       icon: Icon(
            //         _isConfirmPasswordVisible
            //             ? Icons.visibility
            //             : Icons.visibility_off,
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            //         });
            //       },
            //     ),
            //   ),
            // ),
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
