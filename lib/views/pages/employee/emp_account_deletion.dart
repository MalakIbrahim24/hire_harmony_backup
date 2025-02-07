import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/services/emp_delete_account_services.dart';

class EmpAccountDeletionScreen extends StatefulWidget {
  const EmpAccountDeletionScreen({super.key});

  @override
  State<EmpAccountDeletionScreen> createState() =>
      _EmpAccountDeletionScreenState();
}

class _EmpAccountDeletionScreenState extends State<EmpAccountDeletionScreen> {
  final EmpDeleteAccountService _deleteAccountService =
      EmpDeleteAccountService();
  String? selectedReason;
  String? userImage;

  @override
  void initState() {
    super.initState();
    _loadUserImage();
  }

  Future<void> _loadUserImage() async {
    String? image = await _deleteAccountService.fetchUserImage();
    setState(() {
      userImage = image;
    });
  }

  void _handleDeleteAccount(BuildContext context) {
    if (selectedReason == null) {
      _showErrorDialog(
          context, 'Please select a reason for deleting your account.');
    } else {
      _deleteAccountService.deleteAccount(
          context, FirebaseAuth.instance.currentUser!.uid, selectedReason);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Account Deletion',
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
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
            backgroundImage:
                NetworkImage(userImage ?? 'https://via.placeholder.com/150'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'If you want to delete your account and you’re sure, choose a reason.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors().grey),
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
              onPressed: () => _handleDeleteAccount(context),
              child: Text(
                'Delete Account',
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors().white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildReasonsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: AppColors().white,
        shadowColor: AppColors().grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            _buildReasonTile('No longer need the platform'),
            const Divider(),
            _buildReasonTile('Privacy concerns'),
            const Divider(),
            _buildReasonTile('Personal reasons'),
            const Divider(),
            _buildReasonTile('Other'),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonTile(String reason) {
    return RadioListTile<String>(
      value: reason,
      groupValue: selectedReason,
      title: Text(
        reason,
        style: TextStyle(
            fontSize: 16, color: AppColors().navy, fontWeight: FontWeight.w500),
      ),
      onChanged: (value) {
        setState(() {
          selectedReason = value;
        });
      },
    );
  }
}
