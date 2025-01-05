import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class PhotoTabView extends StatefulWidget {
  const PhotoTabView({super.key});

  @override
  State<PhotoTabView> createState() => _PhotoTabViewState();
}

class _PhotoTabViewState extends State<PhotoTabView> {
  File? file;

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagegallery =
        await picker.pickImage(source: ImageSource.gallery);

    if (imagegallery != null) {
      setState(() {
        file = File(imagegallery.path);
      });
    }
  }

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
                TextButton(
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: AppColors().orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    // Navigator to ReviewPage
                  },
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (file != null)
                    WorkPhotoCard(
                      image: Image.file(file!),
                      title: 'Flowers',
                    )
                  else
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 70.0, horizontal: 100),
                      child: Center(
                        child: Text(
                          "No photos added yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors().orange,
        onPressed: () async {
          await getImage();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// بطاقة الصور
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
