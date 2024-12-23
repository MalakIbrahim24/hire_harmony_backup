import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hire_harmony/services/firestore_services.dart';

class AdminService {
  // singleton design pattern
  AdminService._();
  static final instance = AdminService._();

  final firebaseAuth = FirebaseAuth.instance;
  final firestoreService = FirestoreService.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Log Deleted Service
  Future<void> logDeletedService({
    required String adminId, // Admin's UID
    required String serviceName,
    required String employeeName, // For reference
  }) async {
    try {
      // Log the deleted service under the admin's document
      await _firestore
          .collection('users') // Root collection
          .doc(adminId) // Admin's user document
          .collection('deletedServices') // Sub-collection under admin
          .add({
        'service_name': serviceName,
        'employee_name': employeeName, // Optional: name of the employee
        'deleted_at': Timestamp.now(), // Deletion timestamp
      });

      debugPrint("Logged deleted service under admin $adminId: $serviceName");
    } catch (e) {
      debugPrint("Failed to log deleted service: $e");
    }
  }

  // Method to get activity logs

  Stream<List<Map<String, dynamic>>> getActivityLogs(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('activityLogs')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getDeletedAccounts(String uid) {
    return FirebaseFirestore.instance
        .collection('users') // Main 'users' collection
        .doc(uid) // Specific user document
        .collection('deletedAccounts') // Subcollection 'deletedAccounts'
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'name':
                    data['name'] ?? 'Unnamed User', // Default to 'Unnamed User'
                'email': data['email'] ?? 'No Email', // Default to 'No Email'
              };
            }).toList());
  }

  Future<String> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return 'Android - ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return 'iOS - ${iosInfo.utsname.machine}';
    } else {
      return 'Unknown Device';
    }
  }
}
