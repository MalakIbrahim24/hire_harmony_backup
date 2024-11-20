import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/admin/adn_profile_container.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: AppColors().navy,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(children: [
        Text(
          'Settings and privacy',
          style: GoogleFonts.montserratAlternates(
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 80,
        ),
        Divider(
          thickness: 15,
          indent: 150,
          color: AppColors().orange.withOpacity(0.7),
        ),
        const SizedBox(
          height: 50,
        ),
        AdnProfileContainer(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () {},
        ),
        const SizedBox(
          height: 20,
        ),
        AdnProfileContainer(
          icon: Icons.delete_sweep_outlined,
          title: 'Deleted Accounts',
          onTap: () {},
        ),
        const SizedBox(
          height: 20,
        ),
        AdnProfileContainer(
          icon: Icons.timer_off_outlined,
          title: 'Deactivated Accounts',
          onTap: () {},
        ),
        const SizedBox(
          height: 20,
        ),
        AdnProfileContainer(
          icon: Icons.home_repair_service_outlined,
          title: 'Added Servives',
          onTap: () {},
        ),
        const SizedBox(
          height: 50,
        ),
        Divider(
          thickness: 15,
          endIndent: 150,
          color: AppColors().navy,
        ),
      ]),
    );
  }
}
