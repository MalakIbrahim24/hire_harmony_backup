import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: AppColors().white,
          ),
        ),
        backgroundColor: AppColors().orange,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: AppColors().orange,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'What Went Wrong ?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors().white,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors().orange.withAlpha(240),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: TextField(
                maxLines: 5,
                style: TextStyle(
                  color: AppColors().white,
                  fontSize: 16.0,
                ),
                decoration: InputDecoration(
                  hintText: 'You Can Write Your Problem Here',
                  hintStyle: TextStyle(
                    color: AppColors().white,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().navy,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                // Handle submit action
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: AppColors().white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
