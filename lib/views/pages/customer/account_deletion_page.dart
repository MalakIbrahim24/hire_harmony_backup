import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AccountDeletionScreen extends StatelessWidget {
  const AccountDeletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
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
            'Account Deletion',
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
        body: const AccountDeletionBody(),
      ),
    );
  }
}

class AccountDeletionBody extends StatefulWidget {
  const AccountDeletionBody({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountDeletionBodyState createState() => _AccountDeletionBodyState();
}

class _AccountDeletionBodyState extends State<AccountDeletionBody> {
  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 50,
          backgroundImage:
              AssetImage('assets/images/teacher.jpg'), // Replace with image URL
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'If you need to delete an account and you’re sure, choose a reason.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserratAlternates(
              textStyle: TextStyle(
                fontSize: 16,
                color: AppColors().grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            color: AppColors().white,
            shadowColor: AppColors().grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'No longer need the platform',
                  groupValue: selectedReason,
                  title: Text(
                    'No longer need the platform',
                    style: GoogleFonts.montserratAlternates(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors().navy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                ),
                const Divider(),
                RadioListTile<String>(
                  value: 'Privacy concerns',
                  groupValue: selectedReason,
                  title: Text(
                    'Privacy concerns',
                    style: GoogleFonts.montserratAlternates(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors().navy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                ),
                const Divider(),
                RadioListTile<String>(
                  value: 'Personal reasons',
                  groupValue: selectedReason,
                  title: Text(
                    'Personal reasons',
                    style: GoogleFonts.montserratAlternates(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors().navy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                ),
                const Divider(),
                RadioListTile<String>(
                  value: 'Other',
                  groupValue: selectedReason,
                  title: Text(
                    'Other',
                    style: GoogleFonts.montserratAlternates(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: AppColors().navy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Text(
            'Our team will review your request and get back to you within 15 days.',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserratAlternates(
              textStyle: TextStyle(
                fontSize: 14,
                color: AppColors().grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              _showConfirmationDialog(context);
            },
            child: Text(
              'Delete Account',
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(
                  fontSize: 18,
                  color: AppColors().white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors().white,
          shadowColor: AppColors().grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                    'assets/images/teacher.jpg'), // Replace with image URL
              ),
              const SizedBox(height: 10),
              Text(
                'Delete Your Account?',
                style: GoogleFonts.montserratAlternates(
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: AppColors().navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'This will completely erase all your data. You won’t be able to recover your account once it has been deleted.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserratAlternates(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors().grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().orangelight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Add delete logic here
                },
                child: Text(
                  'Confirm & Delete',
                  style: GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: AppColors().orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel & Keep',
                  style: GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: AppColors().navy,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}