import 'package:flutter/material.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class EmpSignUp extends StatelessWidget {
  final String stepText;
  final bool isLastStep;
  final bool isDisplay;

  const EmpSignUp(
      {super.key,
      required this.stepText,
      this.isLastStep = false,
      this.isDisplay = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().orange),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Verify Your Identity",
          style: TextStyle(color: AppColors().black),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(25.0),
          child: Divider(
            thickness: 1,
            color: AppColors().grey,
          ),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 50, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              stepText,
              style: TextStyle(fontSize: 19, color: AppColors().grey2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            CircleAvatar(
              radius: 70,
              backgroundColor: AppColors().grey,
              child: Icon(Icons.image, color: AppColors().grey, size: 50),
            ),
            const SizedBox(height: 60),
            if (!isDisplay)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "UPLOAD FROM DEVICE",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors().grey2, fontWeight: FontWeight.w500),
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
                  onPressed: () {
                  },
                )
                ],
              ),
            if (isDisplay)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "ENSURE YOUR FACE IS WELL-LIT, CLEARLY VISIBLE, AND WITHOUT ACCESSORIES. USE A PLAIN BACKGROUND",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors().grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "CAPTURE WITH CAMERA",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors().grey, fontWeight: FontWeight.w500),
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
                      Icons.camera_alt,
                      color: AppColors().white, 
                    ),
                  ),
                  onPressed: () {
                    
                  },
                )
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                if (isLastStep) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmpSignUp(
                        stepText: "Step 3: Take a live selfie",
                        isDisplay: true,
                        isLastStep: true,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmpSignUp(
                        stepText: "Step 2: Upload the back of your ID",
                        isLastStep: true,
                      ),
                    ),
                  );
                }
              },
              child: Text(
                isDisplay ? 'SUBMIT' : 'NEXT',
                style: TextStyle(fontSize: 16, color: AppColors().white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}