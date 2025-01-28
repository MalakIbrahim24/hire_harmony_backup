// import 'dart:io';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image/image.dart' as img;
// ​
// class IdCardDetector {
//   static const double minAspectRatio = 1.4;
//   static const double maxAspectRatio = 1.7;
  
//   static const int minWidth = 800;
//   static const int minHeight = 500;
// ​
//   static Future<bool> isArabicIdCard(String imagePath) async {
//     try {
//       final File imageFile = File(imagePath);
      
//       if (!await imageFile.exists()) {
//         throw Exception('Image file does not exist');
//       }
// ​
//       final bytes = await imageFile.readAsBytes();
//       final image = img.decodeImage(bytes);
      
//       if (image == null) {
//         throw Exception('Failed to decode image');
//       }
// ​
//       if (!_checkDimensions(image.width, image.height)) {
//         return false;
//       }
// ​
//       if (!_isValidAspectRatio(image.width, image.height)) {
//         return false;
//       }
// ​
//       // Initialize text detector with Arabic script support
//       final textDetector = GoogleMlKit.vision.textDetector();
//       final inputImage = InputImage.fromFilePath(imagePath);
      
//       final RecognizedText recognisedText = await textDetector.processImage(inputImage);
      
//       return _hasArabicIdCardTextPatterns(recognisedText);
//     } catch (e) {
//       print('Error analyzing image: $e');
//       return false;
//     }
//   }
// ​
//   static bool _checkDimensions(int width, int height) {
//     return width >= minWidth && height >= minHeight;
//   }
// ​
//   static bool _isValidAspectRatio(int width, int height) {
//     final aspectRatio = width / height;
//     return aspectRatio >= minAspectRatio && aspectRatio <= maxAspectRatio;
//   }
// ​
//   static bool _hasArabicIdCardTextPatterns(RecognizedText recognisedText) {
//     final text = recognisedText.text;
    
   
//     final arabicPatterns = [
      
//       RegExp(r'بطاقة'),
//       RegExp(r'هوية'),
//       RegExp(r'الوطنية'),
//       RegExp(r'الاسم|اسم'), 
//       RegExp(r'تاريخ الميلاد'), 
//       RegExp(r'الجنسية'), 
//       RegExp(r'رقم'), 
//       RegExp(r'صدر'), 
//       RegExp(r'تاريخ الإصدار'), 
//       RegExp(r'تاريخ الانتهاء'),
//       RegExp(r'محل'), 
//       RegExp(r'الرقم الوطني'), 
     
//       RegExp(r'\d{5,}'),
//     ];
// ​
  
//     int matchCount = 0;
//     for (var pattern in arabicPatterns) {
//       if (pattern.hasMatch(text)) {
//         matchCount++;
//       }
//     }
// ​
    
//     bool hasArabicScript = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    
   
//     return hasArabicScript && matchCount >= 3;
//   }
// ​
 
//   static bool _containsArabicText(String text) {
// ​
//     return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
//   }
// }