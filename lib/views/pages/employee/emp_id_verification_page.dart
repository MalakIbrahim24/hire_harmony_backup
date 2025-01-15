import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';

class EmpIdVerificationPage extends StatefulWidget {
  final String stepText;
  final bool isLastStep;
  final bool isDisplay;
  final bool isDone;

  const EmpIdVerificationPage({
    super.key,
    required this.stepText,
    this.isLastStep = false,
    this.isDisplay = false,
    this.isDone = false,
  });

  @override
  State<EmpIdVerificationPage> createState() => _EmpIdVerificationPageState();
}

class _EmpIdVerificationPageState extends State<EmpIdVerificationPage> {
  File? selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
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
              widget.stepText,
              style: GoogleFonts.montserratAlternates(
                fontSize: 19,
                color: AppColors().grey3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            selectedImage != null
                ? CircleAvatar(
                    radius: 70,
                    backgroundImage: FileImage(selectedImage!),
                  )
                : CircleAvatar(
                    radius: 70,
                    backgroundColor: AppColors().greylight,
                    child: Icon(Icons.person_2_outlined,
                        color: AppColors().grey, size: 50),
                  ),
            const SizedBox(height: 30),
            if (!widget.isDisplay)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "UPLOAD FROM DEVICE",
                    style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      color: AppColors().grey3,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    icon: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors().orange,
                      ),
                      child: Icon(
                        Icons.upload_file,
                        color: AppColors().white,
                      ),
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
            if (widget.isDisplay)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "ENSURE YOUR FACE IS WELL-LIT, CLEARLY VISIBLE, AND WITHOUT ACCESSORIES. USE A PLAIN BACKGROUND",
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 14,
                    color: AppColors().grey3,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "CAPTURE WITH CAMERA",
                  style: GoogleFonts.montserratAlternates(
                    fontSize: 14,
                    color: AppColors().grey3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors().orange,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors().white,
                    ),
                  ),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
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
        ),
      ),
    );
  }
}
