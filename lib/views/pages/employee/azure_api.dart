import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AzureFaceApi {
  final String endpoint = 'https://malakawad24.cognitiveservices.azure.com/';
  final String subscriptionKey =
      'D3o5zzCnopvWzMed67bjWt5BPjjmzu1G3kMbpMbHZGHRxpI3GCxtJQQJ99BAACF24PCXJ3w3AAAKACOGzCQ4'; // Replace with your key

  Future<Map<String, dynamic>> matchFaces(
      String idImagePath, String selfieImagePath) async {
    try {
      // Detect face in ID image
      final idFaceId = await _detectFaceAndGetFaceId(idImagePath);
      if (idFaceId == null) throw Exception('No face detected in ID image.');

      // Detect face in selfie
      final selfieFaceId = await _detectFaceAndGetFaceId(selfieImagePath);
      if (selfieFaceId == null) throw Exception('No face detected in selfie.');

      // Verify faces
      return await _verifyFaces(idFaceId, selfieFaceId);
    } catch (e) {
      print('Error in matching faces: $e');
      throw Exception('Face verification failed: $e');
    }
  }

  Future<String?> _detectFaceAndGetFaceId(String imagePath) async {
    final String url = '$endpoint/face/v1.0/detect?returnFaceId=true';
    final headers = {
      'Content-Type': 'application/octet-stream',
      'Ocp-Apim-Subscription-Key': subscriptionKey,
    };

    try {
      final imageBytes = File(imagePath).readAsBytesSync();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: imageBytes,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data[0]['faceId'];
        }
      } else {
        print('Face detection error: ${response.body}');
      }
    } catch (e) {
      print('Error in face detection: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>> _verifyFaces(
      String faceId1, String faceId2) async {
    final String url = '$endpoint/face/v1.0/verify';
    final headers = {
      'Content-Type': 'application/json',
      'Ocp-Apim-Subscription-Key': subscriptionKey,
    };

    final body = jsonEncode({
      'faceId1': faceId1,
      'faceId2': faceId2,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'isIdentical': data['isIdentical'],
          'confidence': data['confidence'],
        };
      } else {
        print('Face verification error: ${response.body}');
        throw Exception('Verification failed: ${response.body}');
      }
    } catch (e) {
      print('Error in face verification: $e');
      throw Exception('Verification error: $e');
    }
  }
}
