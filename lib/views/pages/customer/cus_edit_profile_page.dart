import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CusEditProfilePage extends StatefulWidget {
  const CusEditProfilePage({super.key});

  @override
  State<CusEditProfilePage> createState() => _CusEditProfilePageState();
}

class _CusEditProfilePageState extends State<CusEditProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = true;
  String? errorMessage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      setState(() {
        isLoading = false;
        errorMessage = "No user is currently logged in.";
      });
      return;
    }
    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['name'] ?? '';
          emailController.text = data['email'] ?? '';
          locationController.text = data['location'] ?? '';
          mobileController.text = data['phone'] ?? '';
          imageUrl = data['img'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "User data not found.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching user data: $e";
      });
    }
  }

  Future<void> _updateField(String field, String value) async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No user is currently logged in.")),
      );
      return;
    }

    try {
      await _firestore.collection('users').doc(currentUser.uid).update({
        field: value,
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Profile updated successfully.",
            style: GoogleFonts.montserratAlternates(
              textStyle: TextStyle(
                color: AppColors().white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: AppColors().green,
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error updating profile: $e",
            style: GoogleFonts.montserratAlternates(
              textStyle: TextStyle(
                color: AppColors().white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: AppColors().red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: AppColors().white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors().navy),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 18,
              color: AppColors().navy,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                  ? NetworkImage(imageUrl!)
                  : const AssetImage('lib/assets/images/default_user.png')
                      as ImageProvider,
            ),
            const SizedBox(height: 10),
            Text(
              nameController.text,
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: AppColors().navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              emailController.text,
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors().grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  buildEditableTile(
                    label: 'Name',
                    controller: nameController,
                    onSave: (value) => _updateField('name', value),
                  ),
                  const SizedBox(height: 10),
                  buildEditableTile(
                    label: 'Email',
                    controller: emailController,
                    onSave: (value) => _updateField('email', value),
                  ),
                  const SizedBox(height: 10),
                  buildEditableTile(
                    label: 'Location',
                    controller: locationController,
                    onSave: (value) => _updateField('location', value),
                  ),
                  const SizedBox(height: 10),
                  buildEditableTile(
                    label: 'Mobile Number',
                    controller: mobileController,
                    onSave: (value) => _updateField('phone', value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableTile({
    required String label,
    required TextEditingController controller,
    required Function(String) onSave,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 18,
              color: AppColors().navy,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors().navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors().greylight,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.save, color: AppColors().orange),
              onPressed: () => onSave(controller.text),
            ),
          ],
        ),
      ],
    );
  }
}
