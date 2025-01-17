import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoTabView extends StatefulWidget {
  final String employeeId; // Pass employee ID to fetch their serviceImages

  const PhotoTabView({super.key, required this.employeeId});

  @override
  State<PhotoTabView> createState() => _PhotoTabViewState();
}

class _PhotoTabViewState extends State<PhotoTabView> {
  File? selectedImage;

  Future<void> _addPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });

      // Show a dialog to add a title and upload
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          final TextEditingController titleController = TextEditingController();

          return AlertDialog(
            title: const Text("Add Photo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedImage != null)
                  Image.file(selectedImage!, height: 150, fit: BoxFit.cover),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final String title = titleController.text.trim();

                  if (title.isEmpty || selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Please select an image and provide a title."),
                      ),
                    );
                    return;
                  }

                  // Upload the image to Supabase
                  final String? imageUrl =
                      await _uploadToSupabase(selectedImage!);

                  if (imageUrl != null) {
                    // Save the image URL and title to Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.employeeId)
                        .collection('serviceImages')
                        .add({'url': imageUrl, 'title': title});

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to upload image."),
                      ),
                    );
                  }
                },
                child: const Text("Upload"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<String?> _uploadToSupabase(File image) async {
    try {
      final String fileName =
          'serviceImages/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      final SupabaseClient supabase = Supabase.instance.client;

      final storageResponse =
          await supabase.storage.from('serviceImages').upload(
                fileName,
                image,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: true,
                ),
              );

      // Check if the upload was successful
      if (storageResponse.isNotEmpty) {
        final String publicUrl =
            supabase.storage.from('serviceImages').getPublicUrl(fileName);
        return publicUrl;
      } else {
        debugPrint('Upload failed: No file path returned.');
      }
    } catch (e) {
      debugPrint('Error uploading to Supabase: $e');
    }
    return null;
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
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
          const SizedBox(height: 10),
          Expanded(
            child: Stack(
              children: [
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
                          Map<String, dynamic>? data =
                              doc.data() as Map<String, dynamic>?;

                          String imageUrl = data?['url'] ?? '';
                          String imageTitle = data?['title'] ?? 'Untitled';

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
                Positioned(
                  bottom: 140,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: _addPhoto,
                    backgroundColor: AppColors().orange,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
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
  final Image image;
  final String title;

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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: image,
            ),
          ),
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
