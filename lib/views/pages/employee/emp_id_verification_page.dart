import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';

class EmpIdVerificationPage extends StatefulWidget {
  const EmpIdVerificationPage({super.key});

  @override
  State<EmpIdVerificationPage> createState() => _EmpIdVerificationPageState();
}

class _EmpIdVerificationPageState extends State<EmpIdVerificationPage> {
  File? idImage;
  File? selfieImage;
  bool isProcessing = false;

  // Function to pick an image from the gallery
  Future<void> _pickImage(ImageSource source, bool isIdImage) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        if (isIdImage) {
          idImage = File(image.path);
        } else {
          selfieImage = File(image.path);
        }
      });
    }
  }

  // Function to navigate to PhonePage
  Future<void> _navigateToPhonePage(Map<String, String> userData) async {
    if (idImage == null || selfieImage == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      // Upload ID and Selfie images to Supabase

      // Navigate to PhonePage with user data and image URLs
      if (!mounted) return;
      Navigator.pushNamed(context, AppRoutes.phonePage, arguments: {
        'name': userData['name']!,
        'email': userData['email']!,
        'password': userData['password']!,
        'idImage': idImage!,
        'selfieImage': selfieImage!,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from SignUpPage
    final Map<String, String>? formData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    if (formData == null) {
      return const Center(
        child: Text(
          'Error: No user data provided.',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        title: Text(
          "Upload ID & Selfie",
          style: GoogleFonts.montserratAlternates(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors().navy,
          ),
        ),
        backgroundColor: AppColors().white,
        iconTheme: IconThemeData(color: AppColors().navy),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Status message
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Upload your ID and a selfie for verification.",
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors().grey3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

                // ID Image Picker
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery, true),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        idImage != null ? FileImage(idImage!) : null,
                    backgroundColor: idImage == null
                        ? AppColors().orangelight
                        : Colors
                            .transparent, // Set orange background when no image
                    child: idImage == null
                        ? Icon(Icons.insert_drive_file,
                            size: 40, color: AppColors().grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Upload ID Picture",
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors().navy,
                  ),
                ),

                const SizedBox(height: 30),

                // Selfie Image Picker
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.camera, false),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        selfieImage != null ? FileImage(selfieImage!) : null,
                    backgroundColor: idImage == null
                        ? AppColors().orangelight
                        : Colors
                            .transparent, // Set orange background when no image
                    child: selfieImage == null
                        ? Icon(Icons.add_a_photo,
                            size: 40, color: AppColors().grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Upload Selfie",
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors().navy,
                  ),
                ),

                const Spacer(),

                // Upload Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (idImage != null && selfieImage != null)
                        ? AppColors().orange
                        : AppColors().grey,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed:
                      (idImage != null && selfieImage != null && !isProcessing)
                          ? () => _navigateToPhonePage(formData)
                          : null,
                  child: isProcessing
                      ? const CircularProgressIndicator()
                      : Text(
                          "Next",
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors().navy,
                          ),
                        ),
                ),
              ],
            ),
<<<<<<< HEAD
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (widget.isLastStep) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmpIdVerificationPage(
                        stepText: "Step 3: Take a live selfie",
                        isDisplay: true,
                        isDone: true,
                      ),
                    ),
                  );
                } else if (widget.isDone) {
                  // Handle submit logic
                  Navigator.pushNamed(
                    context,
                    AppRoutes.empVerificationSuccessPage,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmpIdVerificationPage(
                        stepText: "Step 2: Upload the back of your ID",
                        isLastStep: true,
                      ),
                    ),
                  );
                }
              },
              child: Text(
                widget.isDisplay ? 'SUBMIT' : 'NEXT',
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  color: AppColors().white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
=======
          ),
>>>>>>> d8dcb76a343d751c4ca41c1ef4724bc59c70d9b6
        ),
      ),
    );
  }
}
