import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/customer/build_menu_container.dart';
import 'package:hire_harmony/views/widgets/customer/state_item.dart';

class CusProfilePage extends StatefulWidget {
  const CusProfilePage({super.key});

  @override
  State<CusProfilePage> createState() => _CusProfilePageState();
}

class _CusProfilePageState extends State<CusProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: "Haneen");
  final TextEditingController _emailController =
      TextEditingController(text: "haneen@gmail.com");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: AppColors().white,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: AppColors().navy, fontWeight: FontWeight.bold),
        ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/teacher.jpg'), // Replace with your image
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
                  StatItem(label: ' Orders \n Complete', value: '20'),
                  StatItem(label: ' Support \n Tickets', value: '2'),
                  StatItem(label: ' Pending \n Requests', value: '5'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const buildMenuContainer(),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors().white,
          title: const Text("Edit Profile"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains("@")) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}