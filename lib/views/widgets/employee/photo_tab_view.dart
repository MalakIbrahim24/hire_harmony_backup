import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class PhotoTabView extends StatefulWidget {
  const PhotoTabView({super.key});

  @override
  State<PhotoTabView> createState() => _PhotoTabViewState();
}

class _PhotoTabViewState extends State<PhotoTabView> {
  File? file;
  String? title;

  Future<void> pickAndUploadImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        File imageFile = File(image.path);
        setState(() {
          file = imageFile;
        });

        // Prompt the user for a title
        String? userTitle = await _promptForTitle();
        if (userTitle == null || userTitle.isEmpty) {
          debugPrint('No title provided.');
          return; // Exit if no title is provided
        }

        // Generate a unique file name
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.name}';

        // Upload image to Supabase
        try {
          final String filePath = await supabase
              .Supabase.instance.client.storage
              .from('serviceImages') // Replace with your Supabase bucket name
              .upload('images/$fileName', imageFile);

          // Get the public URL for the uploaded image
          String publicUrl = supabase.Supabase.instance.client.storage
              .from('serviceImages')
              .getPublicUrl(filePath);

          // Store the URL and title in Firestore
          await storeImageUrlAndTitle(publicUrl, userTitle);

          debugPrint(
              'Image uploaded and title saved successfully: $publicUrl, $userTitle');
        } catch (e) {
          debugPrint('Supabase upload error: $e');
        }
      }
    } catch (e) {
      debugPrint('Error picking or uploading image: $e');
    }
  }

  Future<void> storeImageUrlAndTitle(String imageUrl, String title) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get reference to the user's serviceImages collection
        CollectionReference serviceImagesCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('serviceImages');

        // Add the image URL and title as a document
        await serviceImagesCollection.add({
          'url': imageUrl,
          'title': title,
        });

        debugPrint('Image URL and title stored in Firestore successfully.');
      }
    } catch (e) {
      debugPrint('Error storing image URL and title in Firestore: $e');
    }
  }

  Future<String?> _promptForTitle() async {
    String? userInput;
    await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Title'),
          content: TextField(
            onChanged: (value) {
              userInput = value;
            },
            decoration: const InputDecoration(hintText: 'Enter a title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(userInput),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    return userInput;
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
                    // Navigate to ReviewPage
                  },
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
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

                      String imageUrl = data?['url'] ??
                          ''; // Default to empty string if missing
                      String imageTitle =
                          data != null && data.containsKey('title')
                              ? data['title']
                              : 'Untitled'; // Default to 'Untitled' if missing

                      return WorkPhotoCard(
                        image: Image.network(imageUrl, fit: BoxFit.cover),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors().orange,
        onPressed: () async {
          await pickAndUploadImage();
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
