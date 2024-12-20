import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/customer/cus_profile_info.dart';
import 'package:hire_harmony/views/pages/customer/manage_location_page.dart';
import 'package:hire_harmony/views/pages/customer/account_deletion_page.dart';

// ignore: camel_case_types
class buildMenuContainer extends StatefulWidget {
  const buildMenuContainer({super.key});

  @override
  State<buildMenuContainer> createState() => _buildMenuContainerState();
}

// ignore: camel_case_types
class _buildMenuContainerState extends State<buildMenuContainer> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ListTile(
            leading: Icon(
              Icons.brightness_6,
              color: AppColors().orange,
            ),
            title: const Text('Theme'),
            onTap: () {
              setState(() {
                isDarkMode = !isDarkMode;
                // Change the theme
                /* final themeMode =
                          isDarkMode ? ThemeMode.dark : ThemeMode.light;
                      MyApp.of(context).setThemeMode(themeMode);*/
              });
            },
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                  /* final themeMode =
                            isDarkMode ? ThemeMode.dark : ThemeMode.light;
                        MyApp.of(context).setThemeMode(themeMode);*/
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _buildMenuItems(BuildContext context) {
  final menuItems = [
    {'icon': Icons.person, 'text': 'Profile', 'route': const ProfileInfo()},
    {
      'icon': Icons.location_city,
      'text': 'Manage address',
      'route': const ManageLocationPage()
    },
    {'icon': Icons.history, 'text': 'Previous Trips', 'route': null},
    {'icon': Icons.settings, 'text': 'Settings', 'route': null},
    {
      'icon': Icons.info,
      'text': 'Delete Account',
      'route': const AccountDeletionScreen()
    },
    {'icon': Icons.logout, 'text': 'Logout', 'route': null},
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
                }
              },
            ),
            const Divider(
              color: Colors.grey, // Adjust color if needed
              thickness: 0.5,
              height: 1,
            ),
          ],
        ),
      )
      .toList();
}
