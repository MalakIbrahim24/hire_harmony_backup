import 'package:flutter/material.dart';
import 'package:hire_harmony/services/customer_services.dart';
import 'package:hire_harmony/views/pages/salt/add_salt.dart';
import 'package:hire_harmony/views/widgets/main_button.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CusEditProfilePage extends StatefulWidget {
  const CusEditProfilePage({super.key});

  @override
  State<CusEditProfilePage> createState() => _CusEditProfilePageState();
}

class _CusEditProfilePageState extends State<CusEditProfilePage> {
  // final CustomerServices _customerServices = CustomerServices();

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await CustomerServices.instance.fetchUserData();
    if (userData != null) {
      setState(() {
        nameController.text = userData['name'] ?? '';
        emailController.text = userData['email'] ?? '';
        mobileController.text = userData['phone'] ?? '';
        imageUrl = userData['img'] ?? '';
      });
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Add padding to improve UI
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // 🔹 Profile Image
              GestureDetector(
                onTap: () async {
                  String? newImageUrl = await CustomerServices.instance
                      .pickAndUploadProfileImage(context);
                  if (newImageUrl != null) {
                    setState(() {
                      imageUrl = newImageUrl;
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                      ? NetworkImage(imageUrl!)
                      : const AssetImage('lib/assets/images/default_user.png')
                          as ImageProvider,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Editable Fields
              buildEditableTile("Name", nameController, 'name'),
              buildEditableTile("Email", emailController, 'email'),
              buildEditableTile("Mobile Number", mobileController, 'phone'),

              const SizedBox(height: 20),

              // 🔹 Reset Password Button
              MainButton(
                color: AppColors().white,
                text: "Reset Password",
                bgColor: AppColors().orange,
                onPressed: () async {
                  print("🔥 Reset Password button pressed!");
                  await AddSalt().updatePassword(context);
                },
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     await UpdateAllUsers().updateAllUsers();
              //   },
              //   child: Text('Update All Users'),
              // ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Improved Editable Tile with Padding
  Widget buildEditableTile(
      String label, TextEditingController controller, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[200], // Light background for input
        ),
        onEditingComplete: () {
          CustomerServices.instance
              .updateField(context, field, controller.text);
        },
      ),
    );
  }
}
