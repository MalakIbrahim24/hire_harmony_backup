import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class AddTicket extends StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();

  AddTicket({super.key});

  Future<void> saveTicket() async {
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
      await FirebaseFirestore.instance.collection('send ticket').add({
        'uid': user.uid, // إضافة UID الخاص بالمستخدم
        'userName': user.displayName ?? 'Unknown User', // اسم المستخدم
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // تفريغ الحقول عند الحفظ بنجاح
      descriptionController.clear();

      print('Ticket saved successfully!');
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
            color: AppColors().navy,
          ),
        ),
        backgroundColor: AppColors().white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().navy),
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
                onPressed: saveTicket,
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
