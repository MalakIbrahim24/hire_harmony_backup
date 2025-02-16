// import 'dart:io';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:flutter_translate/flutter_translate.dart'; // Ensure you have this dependency

// class IdOcrProcessor {
//   final List<String> idKeywords = [
//     'ID number',
//     'Personal Name',
//     'Mother’s Name',
//     'Date of Birth',
//     'Palestinian Authority',
//     'Place of Issue',
//   ];

//   Future<String> extractArabicText(File imageFile) async {
//     try {
//       final extractedText = await FlutterTesseractOcr.extractText(
//         imageFile.path,
//         language: 'ara',
//         args: {
//           "tessdata": "lib/assets/tessdata",
//           "psm": "6",
//           "preserve_interword_spaces": "1",
//         },
//       );
//       print('Arabic Text: $extractedText');
//       return extractedText;
//     } catch (e) {
//       print('Error extracting text: $e');
//       return '';
//     }
//   }

//   Future<String> translateToEnglish(String arabicText) async {
//     try {
//       final translatedText = translate('text.to_english', args: {'text': arabicText});
//       print('Translated Text: $translatedText');
//       return translatedText;
//     } catch (e) {
//       print('Error translating text: $e');
//       return '';
//     }
//   }

//   bool validateEnglishText(String translatedText) {
//     for (String keyword in idKeywords) {
//       if (translatedText.contains(keyword)) {
//         return true;
//       }
//     }
//     return false;
//   }
// }
