import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:hire_harmony/view_models/cubit/auth_cubit.dart';
import 'package:hire_harmony/views/widgets/customer/state_item.dart';
import 'package:hire_harmony/views/widgets/employee/emp_build_menu_container.dart';

class EmpProfilePage extends StatefulWidget {
  const EmpProfilePage({super.key});

  @override
  State<EmpProfilePage> createState() => _EmpProfilePageState();
}

class _EmpProfilePageState extends State<EmpProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _imageUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    try {
      final User? user = _auth.currentUser; // Get the logged-in user
      if (user == null) return;

      // Fetch the employee's document from Firestore
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        setState(() {
          _nameController.text = doc['name'] ?? '';
          _emailController.text = doc['email'] ?? '';
          _imageUrl = doc['img'] ??
              'https://via.placeholder.com/150'; // Placeholder if no image
        });
      }
    } catch (e) {
      debugPrint('Error fetching employee data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors().white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors().white,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.edit, color: AppColors().orange),
              onPressed: () {
                _showEditProfileDialog(context);
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                _imageUrl ??
                    'https://via.placeholder.com/150', // Placeholder if no image
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _nameController.text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              _emailController.text,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors().white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors().grey,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatItem(label: ' Orders \n Completed', value: '20'),
                  StatItem(label: ' Tickets', value: '2'),
                  StatItem(label: ' Pending \n Requests', value: '5'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(children: [
                EmpBuildMenuContainer(
                  title: 'Profile',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.empProfileInfoPage);
                  },
                ),
                EmpBuildMenuContainer(
                  title: 'Contact us',
                  icon: Icons.contact_page,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.contactUsPage);
                  },
                ),
                EmpBuildMenuContainer(
                  title: 'Delete Account',
                  icon: Icons.info,
                  onTap: () {
                    Navigator.pushNamed(
                        context, AppRoutes.accountDeletionScreen);
                  },
                ),
                EmpBuildMenuContainer(
                  title: 'Logout',
                  icon: Icons.logout,
                  onTap: () async {
                    await authCubit.signOut();
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors().white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              "Edit Profile",
              style: GoogleFonts.montserratAlternates(
                color: AppColors().navy,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: GoogleFonts.montserratAlternates(
                        color: AppColors().grey,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors().grey.withValues(alpha: 0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors().navy,
                        ),
                      ),
                    ),
                    style: GoogleFonts.montserratAlternates(
                      color: AppColors().navy,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Password field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      labelStyle: GoogleFonts.montserratAlternates(
                        color: AppColors().grey,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors().grey.withValues(alpha: 0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors().navy,
                        ),
                      ),
                    ),
                    style: GoogleFonts.montserratAlternates(
                      color: AppColors().navy,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Confirm password field
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: GoogleFonts.montserratAlternates(
                        color: AppColors().grey,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors().grey.withValues(alpha: 0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors().navy,
                        ),
                      ),
                    ),
                    style: GoogleFonts.montserratAlternates(
                      color: AppColors().navy,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm Password cannot be empty";
                      }
                      if (value != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.montserratAlternates(
                  color: AppColors().navy,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // Update user data in Firestore
                    final User? user = _auth.currentUser;
                    if (user != null) {
                      // Update name
                      await _firestore
                          .collection('users')
                          .doc(user.uid)
                          .update({
                        'name': _nameController.text,
                      });

                      // Update password
                      if (passwordController.text.isNotEmpty) {
                        await user.updatePassword(passwordController.text);
                      }
                    }

                    // Update local state
                    setState(() {});

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();

                    // Show success message
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Profile updated successfully!"),
                        backgroundColor: AppColors().green,
                      ),
                    );
                  } catch (e) {
                    debugPrint("Error updating profile: $e");
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            const Text("Failed to update profile. Try again."),
                        backgroundColor: AppColors().red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Save",
                style: GoogleFonts.montserratAlternates(
                  color: AppColors().white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
