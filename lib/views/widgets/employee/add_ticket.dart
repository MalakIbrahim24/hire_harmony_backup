import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AddTicket extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AddTicket({super.key});

  Future<void> saveTicket(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User not logged in');
      return;
    }

    final String description = descriptionController.text.trim();

    if (description.isEmpty) {
      print('Description is required');
      return;
    }

    try {
      final DocumentSnapshot employeeDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (employeeDoc.exists) {
        final data = employeeDoc.data() as Map<String, dynamic>;

        final name = data['name'] ?? 'unknown user';
        await FirebaseFirestore.instance.collection('ticketsSent').add({
          'uid': user.uid, // User's UID
          'name': name, // User's name
          'description': description,
          'timestamp': FieldValue.serverTimestamp(),
          'state': 'unresolved',
          'response': 'No response yet',
        });

        // Clear the description field
        descriptionController.clear();

        // Navigate back to the previous page
        if (!context.mounted) return;
        Navigator.pop(context);

        print('Ticket saved successfully!');
      }
    } catch (e) {
      print('Error saving ticket: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().navy,
      appBar: AppBar(
        title: Text(
          'Add Ticket',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              const Text(
                'Add Your Ticket',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(
                  labelText: 'Problem Description',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors().orange,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  saveTicket(context); // Pass context to the saveTicket method
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors().white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
