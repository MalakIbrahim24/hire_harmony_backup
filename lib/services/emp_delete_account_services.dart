import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';

class EmpDeleteAccountService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> fetchUserImage() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc['img'] ??
            'https://via.placeholder.com/150'; // Placeholder image
      }
    } catch (e) {
      debugPrint('Error fetching user image: $e');
    }
    return null;
  }

  Future<void> getUserCategories(String userID) async {
    try {
      QuerySnapshot empCategoriesSnapshot = await _firestore
          .collection('users')
          .doc(userID)
          .collection('empcategories')
          .get();

      List<String> allCategories = [];
      for (var doc in empCategoriesSnapshot.docs) {
        List<dynamic> categories = doc['categories'] ?? [];
        allCategories.addAll(categories.cast<String>());
      }
      await decrementEmpNumForCategories(allCategories, userID);
    } catch (e) {
      debugPrint('Error fetching user categories: $e');
    }
  }

  Future<void> decrementEmpNumForCategories(
      List<String> categories, String employeeId) async {
    for (String categoryName in categories) {
      categoryName = categoryName.trim();

      QuerySnapshot categorySnapshot = await _firestore
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .get();

      if (categorySnapshot.docs.isEmpty) {
        continue;
      }

      String categoryId = categorySnapshot.docs.first.id;
      DocumentSnapshot categoryDoc =
          await _firestore.collection('categories').doc(categoryId).get();

      int currentEmpNum = (categoryDoc['empNum'] ?? 0) as int;
      int updatedEmpNum = (currentEmpNum > 0) ? currentEmpNum - 1 : 0;

      await _firestore.collection('categories').doc(categoryId).update({
        'empNum': updatedEmpNum,
        'workers': FieldValue.arrayRemove([employeeId]),
      });
    }
  }

  Future<void> deleteAccount(BuildContext context, String userId, String? selectedReason) async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final password = await _getPasswordFromUser(context);
        if (password == null || password.isEmpty) {
          _showErrorDialog(context, 'Password is required to delete your account.');
          return;
        }

        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }

      await getUserCategories(user!.uid);
      final DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      await _firestore.collection('deleted_users').doc(user.uid).set({
        'selectedReason': selectedReason,
      }, SetOptions(merge: true));

      await _firestore.collection('deleted_users').doc(user.uid).set(
            userData.data() as Map<String, dynamic>,
            SetOptions(merge: true),
          );

      await FirestoreService.instance.deleteData(documentPath: 'users/$userId');
      await user.delete();

      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginPage,
        (Route<dynamic> route) => route.settings.name == AppRoutes.welcomePage,
      );
    } catch (e) {
      debugPrint('Error deleting account: $e');
      _showErrorDialog(context, 'Failed to delete account. Try again.');
    }
  }

  Future<String?> _getPasswordFromUser(BuildContext context) async {
    String? password;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Re-enter Password'),
          content: TextField(
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            onChanged: (value) {
              password = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
    return password;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
}
