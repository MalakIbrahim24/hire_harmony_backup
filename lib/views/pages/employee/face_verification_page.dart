// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hire_harmony/utils/app_colors.dart';
// import 'package:hire_harmony/utils/route/app_routes.dart';
// import 'package:hire_harmony/views/pages/employee/azure_api.dart';

// class FaceVerificationPage extends StatefulWidget {
//   final String idImagePath; // Path of the ID image
//   final String selfieImagePath; // Path of the live selfie image

//   const FaceVerificationPage({
//     super.key,
//     required this.idImagePath,
//     required this.selfieImagePath,
//   });

//   @override
//   State<FaceVerificationPage> createState() => _FaceVerificationPageState();
// }

// class _FaceVerificationPageState extends State<FaceVerificationPage> {
//   bool isProcessing = true;
//   String statusMessage = "Analyzing faces...";
//   double? confidenceLevel;

//   @override
//   void initState() {
//     super.initState();
//     _verifyFaces(); // Start the verification process on page load
//   }

//   Future<void> _verifyFaces() async {
//     try {
//       final AzureFaceApi faceApi = AzureFaceApi();
//       final result = await faceApi.matchFaces(
//         widget.idImagePath,
//         widget.selfieImagePath,
//       );

//       setState(() {
//         isProcessing = false;
//         if (result["isIdentical"] == true) {
//           confidenceLevel = result["confidence"];
//           statusMessage = "Verification Successful!";
//         } else {
//           confidenceLevel = result["confidence"];
//           statusMessage = "Face verification failed.";
//         }
//       });

//       // Navigate to success page if successful
//       if (result["isIdentical"] == true) {
//         Future.delayed(const Duration(seconds: 2), () {
//           // ignore: use_build_context_synchronously
//           Navigator.pushNamed(context, AppRoutes.empVerificationSuccessPage);
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isProcessing = false;
//         if (e.toString().contains('No face detected')) {
//           statusMessage = "No face detected. Please upload clear images.";
//         } else {
//           statusMessage = "An error occurred: $e";
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors().white,
//       appBar: AppBar(
//         backgroundColor: AppColors().white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: AppColors().navy),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           "Face Verification",
//           style: GoogleFonts.montserratAlternates(
//             fontSize: 20,
//             color: AppColors().navy,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: Center(
//         child: isProcessing
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     color: AppColors().orange,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     "Analyzing faces...",
//                     style: GoogleFonts.montserratAlternates(
//                       fontSize: 16,
//                       color: AppColors().grey3,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     statusMessage == "Verification Successful!"
//                         ? Icons.check_circle
//                         : Icons.error,
//                     color: statusMessage == "Verification Successful!"
//                         ? AppColors().green
//                         : AppColors().red,
//                     size: 80,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     statusMessage,
//                     style: GoogleFonts.montserratAlternates(
//                       fontSize: 18,
//                       color: statusMessage == "Verification Successful!"
//                           ? AppColors().green
//                           : AppColors().red,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   if (confidenceLevel != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         "Confidence: ${(confidenceLevel! * 100).toStringAsFixed(2)}%",
//                         style: GoogleFonts.montserratAlternates(
//                           fontSize: 16,
//                           color: AppColors().grey3,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   if (statusMessage != "Verification Successful!")
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors().orange,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 15, horizontal: 30),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context); // Retry the verification
//                       },
//                       child: Text(
//                         "Try Again",
//                         style: GoogleFonts.montserratAlternates(
//                           fontSize: 16,
//                           color: AppColors().white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
