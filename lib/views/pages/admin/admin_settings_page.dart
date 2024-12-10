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
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Container(
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: [
                        Text(
                          'Terms and Conditions',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 28,
                            color: AppColors().navy,
                          ),
                        ),
                        Text(
                          'Our app aims to help people and we allow no inappropraite act, we are looking for the comfort and happiness of our customers.',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: AppColors().navy,
                          ),
                        ),
                        Text(
                          'Here are the following rules and regulation that you are kindly requested to follow: ',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: AppColors().navy,
                          ),
                        ),
                        Text(
                          '1. No harmful threats or words/slangs are allowed\n 2. No scamming or refusing to pay, people that refuse to pay will be dealt with through the law, and they shall be punished the proper way.',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: AppColors().navy,
                          ),
                        ),
                        Text(
                          '3. Reciepts are always a must to keep to avoid any confliction and it will be used a evidence in the court of law',
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: AppColors().navy,
                          ),
                        ),
                        const Text('4.')
                      ],
                    ),
                  ),
                ),
              );
            }),
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
