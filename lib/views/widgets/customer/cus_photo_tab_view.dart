import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CusPhotoTabView extends StatefulWidget {
  final String employeeId;

  const CusPhotoTabView({super.key, required this.employeeId});

  @override
  State<CusPhotoTabView> createState() => _CusPhotoTabViewState();
}

class _CusPhotoTabViewState extends State<CusPhotoTabView> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),

            /// Firestore Stream to Fetch Images
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.employeeId)
                    .collection('serviceImages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No photos added yet",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  /// Convert Firestore documents to a list
                  var photos = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic>? data =
                        doc.data() as Map<String, dynamic>?;

                    String imageUrl = data?['url'] ?? '';
                    String imageTitle = data?['title'] ?? 'Untitled';

                    return WorkPhotoCard(
                      imageUrl: imageUrl,
                      title: imageTitle,
                    );
                  }).toList();

                  return GridView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two images per row
                      crossAxisSpacing: 10, // Space between columns
                      mainAxisSpacing: 10, // Space between rows
                      childAspectRatio: 1.0, // Square images
                    ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return photos[index]; // Display each photo in grid
                    },
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

/// WorkPhotoCard Widget to Display Each Image
class WorkPhotoCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const WorkPhotoCard({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          /// Display the image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
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
          ),

          /// Title overlay at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              color: Colors.black.withOpacity(0.6),
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
