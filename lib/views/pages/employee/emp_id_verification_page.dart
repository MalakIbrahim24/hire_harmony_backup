import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';

class EmpIdVerificationPage extends StatelessWidget {
  final String stepText;
  final bool isLastStep;
  final bool isDisplay;
  final bool isDone;

  const EmpIdVerificationPage(
      {super.key,
      required this.stepText,
      this.isLastStep = false,
      this.isDisplay = false,
      this.isDone = false});

  @override
  Widget build(BuildContext context) {
    //   final Map<String, String>? formData =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    // if (formData == null) {
    //   return const Center(
    //     child: Text(
    //       'Error: No user data provided.',
    //       style: TextStyle(fontSize: 18, color: Colors.red),
    //     ),
    //   );
    // }
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
              fontWeight: FontWeight.w500),
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
              stepText,
              style: GoogleFonts.montserratAlternates(
                  fontSize: 19, color: AppColors().grey3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            CircleAvatar(
              radius: 70,
              backgroundColor: AppColors().greylight,
              child: Icon(Icons.person_2_outlined,
                  color: AppColors().grey, size: 50),
            ),
            const SizedBox(height: 60),
            if (!isDisplay)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "UPLOAD FROM DEVICE",
                    style: GoogleFonts.montserratAlternates(
                        fontSize: 14,
                        color: AppColors().grey3,
                        fontWeight: FontWeight.w500),
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
                    onPressed: () {},
                  )
                ],
              ),
            if (isDisplay)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "ENSURE YOUR FACE IS WELL-LIT, CLEARLY VISIBLE, AND WITHOUT ACCESSORIES. USE A PLAIN BACKGROUND",
                  style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      color: AppColors().grey3,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "CAPTURE WITH CAMERA",
                  style: GoogleFonts.montserratAlternates(
                      fontSize: 14,
                      color: AppColors().grey3,
                      fontWeight: FontWeight.w500),
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
                  onPressed: () {},
                )
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
                if (isLastStep) {
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
                } else if (isDone) {
                  Navigator.pushNamed(
                      context, AppRoutes.empVerificationSuccessPage);
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
                isDisplay ? 'SUBMIT' : 'NEXT',
                style: GoogleFonts.montserratAlternates(
                    fontSize: 18,
                    color: AppColors().white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
