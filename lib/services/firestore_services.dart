import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class FirestoreService {
  //singleton
  FirestoreService._();
  static final instance = FirestoreService._();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //add and update data
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = firestore.doc(path);
    debugPrint('$path: $data');
    await reference.set(data);
  }

  Future<String> getUserRoleByUid(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        String role = userDoc['role'] ?? "unknown";
        debugPrint("Role found: $role");
        return role;
      } else {
        debugPrint("No document found for UID: $uid");
        return "unknown";
      }
    } catch (e) {
      print("Error fetching user role: $e");
      return "unknown"; // Handle any issues by returning an "unknown" role
    }
  }

  Future<void> deleteData({required String path}) async {
    final reference = firestore.doc(path);
    debugPrint('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    //filtering the list coming back from the stream
    Query Function(Query query)? queryBuilder,
    //sorting the  list coming back from the stream
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              builder((snapshot.data() as Map<String, dynamic>), snapshot.id))
          .where((value) => value != null)
          .toList();

      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String path) builder,
  }) {
    final reference = firestore.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        builder(snapshot.data() as Map<String, dynamic>, snapshot.id));
  }

// one time request for the document
  Future<T> getDocument<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String path) builder,
  }) async {
    final reference = firestore.doc(path);
    final snapshot = await reference.get();
    return builder(snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

// one time request for a list of documents
  Future<List<T>> getCollection<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String path) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    Query query = firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = await query.get();
    final result = snapshots.docs
        .map((snapshot) =>
            builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  // Method to log activity
  Future<void> logActivity({
    required String uid,
    required String action,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('activityLogs')
          .add({
        'action': action,
        'timestamp': Timestamp.now(),
        'device': defaultTargetPlatform.toString(),
      });
      debugPrint("Activity logged: $action for user: $uid");
    } catch (e) {
      debugPrint("Error logging activity: $e");
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

  Future<bool> reauthenticateUser(String currentPassword) async {
    User? user = _auth.currentUser;

    if (user != null && user.email != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        return true;
      } catch (e) {
        debugPrint("Re-authentication failed: $e");
        Fluttertoast.showToast(
          msg: "Incorrect current password",
          textColor: AppColors().white,
          backgroundColor: AppColors().red,
        );
        return false;
      }
    }
    return false;
  }

  Future<void> updatePassword(String newPassword) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        String newPasswordHash = hashPassword(newPassword);

        await _firestore.collection('users').doc(user.uid).update({
          'lastPasswordChange': Timestamp.now(),
          'passwordHash': newPasswordHash,
        });

        Fluttertoast.showToast(
          msg: "Password updated successfully",
          textColor: AppColors().white,
          backgroundColor: AppColors().orange,
        );
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error updating password: $e",
          textColor: AppColors().white,
          backgroundColor: AppColors().red,
        );
      }
    }
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> isSameAsCurrentPassword(String newPassword) async {
    User? user = _auth.currentUser;

    if (user != null && user.email != null) {
      try {
        // Get the current password hash
        String currentPasswordHash = hashPassword(newPassword);

        // Fetch the user's document from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        // Check if the current hashed password matches the new password hash
        if (userDoc.exists && userDoc['passwordHash'] == currentPasswordHash) {
          return true;
        }
      } catch (e) {
        debugPrint("Error checking current password: $e");
      }
    }
    return false;
  }

  // Method to get and update notification settings
  // Future<Map<String, dynamic>> getNotificationSettings(String uid) async {
  //   DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
  //   return doc.data()?['notifications'] ?? {};
  // }

  // Future<void> updateNotificationSettings(
  //     String uid, Map<String, dynamic> settings) async {
  //   await _firestore
  //       .collection('users')
  //       .doc(uid)
  //       .update({'notifications': settings});
  // }
}
