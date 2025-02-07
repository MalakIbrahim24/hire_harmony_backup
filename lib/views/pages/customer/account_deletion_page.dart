import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/customer_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AccountDeletionScreen extends StatefulWidget {
  const AccountDeletionScreen({super.key});

  @override
  State <AccountDeletionScreen>  createState() => _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends State<AccountDeletionScreen> {
  String? selectedReason;
  String? userImage;
  final CustomerServices _customerServices = CustomerServices();

  @override
  void initState() {
    super.initState();
    _loadUserImage();
  }

  Future<void> _loadUserImage() async {
    String? imageUrl = await _customerServices.fetchUserImage();
    setState(() {
      userImage = imageUrl ??
          'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Account Deletion',
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: userImage != null && userImage!.isNotEmpty
                ? NetworkImage(userImage!)
                : const NetworkImage(
                    'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'If you want to delete your account and you’re sure, choose a reason.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserratAlternates(
                textStyle: TextStyle(fontSize: 16, color: AppColors().grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildReasonsCard(),
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
                if (selectedReason == null) {
                  _customerServices.showErrorDialog(context,
                      "Please select a reason for deleting your account.");
                } else {
                  _customerServices.deleteAccount(context, selectedReason);
                }
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
      ),
    );
  }

  Widget _buildReasonsCard() {
    return Column(
      children: [
        'No longer need the platform',
        'Privacy concerns',
        'Personal reasons',
        'Other'
      ]
          .map((reason) => RadioListTile<String>(
                value: reason,
                groupValue: selectedReason,
                title: Text(reason),
                onChanged: (value) {
                  setState(() {
                    selectedReason = value;
                  });
                },
              ))
          .toList(),
    );
  }
}
