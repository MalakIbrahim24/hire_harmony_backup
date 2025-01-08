import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/employee/face_verification_page.dart';

class EmpIdVerificationPage extends StatefulWidget {
  const EmpIdVerificationPage({super.key});

  @override
  State<EmpIdVerificationPage> createState() => _EmpIdVerificationPageState();
}

class _EmpIdVerificationPageState extends State<EmpIdVerificationPage> {
  File? idImage;
  File? selfieImage;

  Future<void> _pickImage(ImageSource source, bool isIdImage) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          if (isIdImage) {
            idImage = File(image.path);
          } else {
            selfieImage = File(image.path);
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().navy),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Verify Your Identity",
          style: GoogleFonts.montserratAlternates(
            fontSize: 20,
            color: AppColors().navy,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors().white,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 50, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Upload your ID and take a selfie for verification",
              style: GoogleFonts.montserratAlternates(
                fontSize: 19,
                color: AppColors().grey3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _imagePickerWidget("Upload ID Picture", idImage, true),
            const SizedBox(height: 30),
            _imagePickerWidget("Upload Selfie", selfieImage, false),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: (idImage != null && selfieImage != null)
                    ? AppColors().orange
                    : AppColors().grey,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: (idImage != null && selfieImage != null)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaceVerificationPage(
                            idImagePath: idImage!.path,
                            selfieImagePath: selfieImage!.path,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(
                "SUBMIT",
                style: GoogleFonts.montserratAlternates(
                  fontSize: 18,
                  color: AppColors().white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePickerWidget(String label, File? imageFile, bool isIdImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.montserratAlternates(
            fontSize: 14,
            color: AppColors().grey3,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickImage(ImageSource.gallery, isIdImage),
          child: CircleAvatar(
            radius: 70,
            backgroundColor: AppColors().greylight,
            backgroundImage: imageFile != null ? FileImage(imageFile) : null,
            child: imageFile == null
                ? Icon(Icons.upload_file, color: AppColors().grey, size: 50)
                : null,
          ),
        ),
      ],
    );
  }
}
