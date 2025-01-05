import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/customer/cus_profile_info.dart';
import 'package:hire_harmony/views/pages/customer/account_deletion_page.dart';

// ignore: camel_case_types
class buildMenuContainer extends StatefulWidget {
  const buildMenuContainer({super.key});

  @override
  State<buildMenuContainer> createState() => _buildMenuContainerState();
}

// ignore: camel_case_types
class _buildMenuContainerState extends State<buildMenuContainer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors().white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Column(
              children: _buildMenuItems(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.person,
        'text': 'Profile',
        'route': const CusProfileInfo(),
      },
      {
        'icon': Icons.settings,
        'text': 'Settings',
        'route': null,
      },
      {
        'icon': Icons.info,
        'text': 'Delete Account',
        'route': const AccountDeletionScreen(),
      },
      {
        'icon': Icons.contact_page,
        'text': 'Contact us',
        'route': null,
      },
      {
        'icon': Icons.logout,
        'text': 'Logout',
        'route': null,
        'action': () async {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/log-in-page', (route) => false);
        }, // Add logout action
      },
    ];

    return menuItems
        .map(
          (item) => Column(
            children: [
              ListTile(
                leading: Icon(
                  item['icon'] as IconData,
                  color: AppColors().orange,
                ),
                title: Text(item['text'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (item['route'] != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => item['route'] as Widget,
                      ),
                    );
                  } else if (item['action'] != null) {
                    // Safely call the action with a null check
                    (item['action'] as Function)();
                  }
                },
              ),
            ],
          ),
        )
        .toList();
  }
}
