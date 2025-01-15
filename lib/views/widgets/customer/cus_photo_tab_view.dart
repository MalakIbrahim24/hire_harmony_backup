import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CusPhotoTabView extends StatefulWidget {
  final String employeeId; // Pass employee ID to fetch their serviceImages

  const CusPhotoTabView({super.key, required this.employeeId});

  @override
  State<CusPhotoTabView> createState() => _CusPhotoTabViewState();
}

class _CusPhotoTabViewState extends State<CusPhotoTabView> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Previous Work Photos',
                  style: GoogleFonts.montserratAlternates(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors().grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.employeeId) // Use the employee's ID
                    .collection('serviceImages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 70.0, horizontal: 100),
                      child: Center(
                        child: Text(
                          "No photos added yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return Row(
                    children: snapshot.data!.docs.map((doc) {
                      // Safely retrieve the 'url' and 'title' fields
                      Map<String, dynamic>? data =
                          doc.data() as Map<String, dynamic>?;

                      String imageUrl = data?['url'] ?? ''; // Default to empty string if missing
                      String imageTitle = data != null && data.containsKey('title')
                          ? data['title']
                          : 'Untitled'; // Default to 'Untitled' if missing

                      return WorkPhotoCard(
                        image: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                "Image not found",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                        title: imageTitle,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WorkPhotoCard widget
class WorkPhotoCard extends StatelessWidget {
  final Image image; // Image widget passed directly
  final String title; // Title for the card

  const WorkPhotoCard({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 180,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Display the image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: image, // Use the provided Image widget directly
            ),
          ),
          // Add title overlay at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: Colors.black.withValues(alpha: 0.6),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors().white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}