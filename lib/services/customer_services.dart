import 'dart:io';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hire_harmony/api/firebase_api.dart';
import 'package:hire_harmony/views/pages/location_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/utils/route/app_routes.dart';
import 'package:image_picker/image_picker.dart';

class CustomerServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//account_deletion_screen
  /// Fetch User Profile Image
  Future<String?> fetchUserImage() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      return doc.exists ? doc['img'] : null;
    } catch (e) {
      debugPrint('Error fetching user image: $e');
      return null;
    }
  }

  /// Show Error Dialog
  void showErrorDialog(BuildContext context, String message) {
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

  /// Request Password from User
  Future<String?> requestUserPassword(BuildContext context) async {
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

  Future<void> deleteAccount(
      BuildContext context, String? selectedReason) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      showErrorDialog(context, "User is not logged in.");
      return;
    }

    try {
      // 🔹 Step 1: Ask the user for their password
      final password = await requestUserPassword(context);
      if (password == null || password.isEmpty) {
        showErrorDialog(
            // ignore: use_build_context_synchronously
            context,
            'Password is required to delete your account.');
        return;
      }

      // 🔹 Step 2: Re-authenticate the user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // 🔹 Step 3: Reference to user's document
      final DocumentReference userDoc =
          _firestore.collection('users').doc(user.uid);

      // 🔹 Step 4: Delete all subcollections (e.g., `activityLogs`)
      await _deleteUserSubcollections(user.uid);

      // 🔹 Step 5: Retrieve user data before deletion
      final DocumentSnapshot userData = await userDoc.get();

      // 🔹 Step 6: Move user data to `deleted_users`
      if (userData.exists) {
        await _firestore.collection('deleted_users').doc(user.uid).set({
          'selectedReason': selectedReason,
          ...userData.data() as Map<String, dynamic>,
        });
      }

      // 🔹 Step 7: Delete the user document from Firestore
      await userDoc.delete();

      // 🔹 Step 8: Delete user from Firebase Authentication
      await user.delete();

      // 🔹 Step 9: Navigate to the login screen
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginPage,
        (Route<dynamic> route) => route.settings.name == AppRoutes.welcomePage,
      );

      Fluttertoast.showToast(
        msg: "Account deleted successfully.",
        textColor: AppColors().white,
        backgroundColor: AppColors().red,
      );

      debugPrint("✅ User account successfully deleted!");
    } catch (e) {
      debugPrint('❌ Error during account deletion: $e');
      showErrorDialog(
          context, 'Failed to delete your account. Please try again.');
    }
  }

  Future<void> _deleteUserSubcollections(String userId) async {
    final DocumentReference userDoc =
        _firestore.collection('users').doc(userId);

    // 🔹 List of subcollections to delete
    List<String> subcollections = [
      'activityLogs', // Add any other subcollections here if needed
    ];

    for (String subcollection in subcollections) {
      final QuerySnapshot subcollectionDocs =
          await userDoc.collection(subcollection).get();

      for (var doc in subcollectionDocs.docs) {
        await doc.reference.delete();
      }

      debugPrint("✅ Deleted all documents from subcollection: $subcollection");
    }
  }

//community
  Future<List<Map<String, dynamic>>> fetchAllEmployeeItems() async {
    try {
      final employeesSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'employee')
          .get();

      final List<Map<String, dynamic>> allItems = [];

      for (var employeeDoc in employeesSnapshot.docs) {
        final employeeData = employeeDoc.data();
        final employeeId = employeeDoc.id;

        final itemsSnapshot = await _firestore
            .collection('users')
            .doc(employeeId)
            .collection('items')
            .get();

        for (var itemDoc in itemsSnapshot.docs) {
          final itemData = itemDoc.data();
          allItems.add({
            'employeeId': employeeId,
            'employeeName': employeeData['name'] ?? 'Unknown Employee',
            'employeeImg':
                employeeData['img'] ?? 'https://via.placeholder.com/150',
            'itemId': itemDoc.id,
            'itemName': itemData['name'] ?? 'Unnamed Item',
            'itemImg': itemData['image'] ?? 'https://via.placeholder.com/150',
            'itemAbout': itemData['description'] ?? 'No description provided',
            'itemRating': itemData['rating'] ?? '0',
          });
        }
      }

      return allItems;
    } catch (e) {
      debugPrint("❌ Error fetching employee items: $e");
      return [];
    }
  }

  /// 🔹 Filter items by name
  List<Map<String, dynamic>> filterItems(
      String query, List<Map<String, dynamic>> allItems) {
    if (query.isEmpty) return allItems;

    return allItems
        .where((item) =>
            item['itemName'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Future<Map<String, dynamic>?> fetchUserData() async {
  //   final User? currentUser = _auth.currentUser;
  //   if (currentUser == null) return null;

  //   try {
  //     final DocumentSnapshot userDoc =
  //         await _firestore.collection('users').doc(currentUser.uid).get();

  //     if (userDoc.exists) {
  //       return userDoc.data() as Map<String, dynamic>;
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Error fetching user data: $e");
  //   }
  //   return null;
  // }

//cus_edit_profile_page
  /// Update a Field in Firestore
  Future<void> updateField(
      BuildContext context, String field, String value) async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      showErrorMessage(context, "No user is currently logged in.");
      return;
    }

    try {
      await _firestore.collection('users').doc(currentUser.uid).update({
        field: value,
      });

      // ignore: use_build_context_synchronously
      showSuccessMessage(context, "Profile updated successfully.");
    } catch (e) {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, "Error updating profile: $e");
    }
  }

  /// Pick and Upload Profile Image to Supabase
  Future<String?> pickAndUploadProfileImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        File imageFile = File(image.path);

        // Ask for confirmation
        // ignore: use_build_context_synchronously
        final bool confirmed = await showConfirmationDialog(context);
        if (!confirmed) return null;

        // Generate a unique file name
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.name.replaceAll(" ", "_")}';

        try {
          // Upload image to Supabase
          final String filePath = await supabase
              .Supabase.instance.client.storage
              .from('serviceImages')
              .upload('profile/$fileName', imageFile);

          // Get the public URL for the uploaded image
          String publicUrl = supabase.Supabase.instance.client.storage
              .from('serviceImages')
              .getPublicUrl(filePath.replaceFirst('serviceImages/', ''));

          debugPrint('✅ Uploaded image URL: $publicUrl');

          // Update Firestore with the new profile image URL
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({'img': publicUrl});

          return publicUrl;
        } catch (e) {
          debugPrint('❌ Error uploading image to Supabase: $e');
        }
      }
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
    }
    return null;
  }

  /// Show Confirmation Dialog before updating the profile image
  Future<bool> showConfirmationDialog(BuildContext context) async {
    bool result = false;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Image'),
          content: const Text(
              'Do you want to use this image as your profile picture?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ).then((value) => result = value ?? false);
    return result;
  }

  /// Show Success Message
  void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              TextStyle(color: AppColors().white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors().green,
      ),
    );
  }

  /// Show Error Message
  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              TextStyle(color: AppColors().white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors().red,
      ),
    );
  }
  // cus_home_page functions

  Future<String> fetchUserName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc.data()?['name'] ?? "User";
      }
    }
    return "User";
  }

  Future<void> updateCategoryWorkerCounts() async {
    QuerySnapshot categoriesSnapshot =
        await _firestore.collection('categories').get();
    Map<String, int> categoryWorkerCount = {};

    for (var categoryDoc in categoriesSnapshot.docs) {
      categoryWorkerCount[categoryDoc.id] = 0;
    }

    QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

    for (var userDoc in usersSnapshot.docs) {
      String userId = userDoc.id;
      QuerySnapshot empCategoriesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('empcategories')
          .get();

      for (var empCategoryDoc in empCategoriesSnapshot.docs) {
        Map<String, dynamic> categoryData =
            empCategoryDoc.data() as Map<String, dynamic>;
        List<dynamic> categoryNames = categoryData['categories'] ?? [];

        for (String categoryName in categoryNames) {
          categoryName = categoryName.trim();
          for (var categoryDoc in categoriesSnapshot.docs) {
            Map<String, dynamic> categoryDocData =
                categoryDoc.data() as Map<String, dynamic>;
            String categoryDocName =
                categoryDocData['name']?.toString().trim() ?? '';

            if (categoryDocName == categoryName) {
              categoryWorkerCount[categoryDoc.id] =
                  (categoryWorkerCount[categoryDoc.id] ?? 0) + 1;
            }
          }
        }
      }
    }

    for (var entry in categoryWorkerCount.entries) {
      await _firestore.collection('categories').doc(entry.key).update({
        'empNum': entry.value,
      });
    }
  }

  Future<void> checkUserLocation(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 10));
    final user = _auth.currentUser;
    if (user != null) {
      final isLocationSaved = await FirebaseApi().isUserLocationSaved(user.uid);
      if (!isLocationSaved) {
        await Get.to(() => const LocationPage());
      }
    }
  }
  //generic function

  Future<Map<String, dynamic>?> fetchUserData() async {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    try {
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return {'error': "Error fetching user data: $e"};
    }
  }

  // cus_profile_page

  Future<int> fetchOrderCount() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return 0;

    try {
      final QuerySnapshot ordersSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('completedOrders')
          .get();

      return ordersSnapshot.size;
    } catch (e) {
      return 0;
    }
  }

  Future<int> fetchTicketCount() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return 0;

    try {
      final QuerySnapshot ticketsSnapshot = await _firestore
          .collection('ticketsSent')
          .where('uid', isEqualTo: currentUser.uid)
          .get();

      return ticketsSnapshot.size;
    } catch (e) {
      return 0;
    }
  }

  Future<int> fetchPendingRequestCount() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return 0;

    try {
      final QuerySnapshot requestsSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('sentRequests')
          .where('status', isEqualTo: 'pending')
          .get();

      return requestsSnapshot.size;
    } catch (e) {
      return 0;
    }
  }
  //custom_buttom_navbar

  Stream<int> listenForPendingOrders() {
    final String? loggedInUserId = _auth.currentUser?.uid;
    if (loggedInUserId == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('users')
        .doc(loggedInUserId)
        .collection('orders')
        .where('status', isEqualTo: 'in progress')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  //employees_under_category_page.dart
  /// 🔹 Fetch user location from Firestore
  Future<Position?> getCurrentLocation() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        print("❌ No authenticated user found.");
        return null;
      }

      final String userId = user.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('location') &&
            data['location'] is Map<String, dynamic>) {
          var location = data['location'] as Map<String, dynamic>;
          double latitude =
              double.tryParse(location['latitude'].toString()) ?? 0.0;
          double longitude =
              double.tryParse(location['longitude'].toString()) ?? 0.0;

          if (latitude != 0.0 && longitude != 0.0) {
            return Position(
              latitude: latitude,
              longitude: longitude,
              timestamp: DateTime.now(),
              accuracy: 0.0,
              altitude: 0.0,
              altitudeAccuracy: 0.0,
              heading: 0.0,
              headingAccuracy: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0,
            );
          }
        }
      }
      return null;
    } catch (e) {
      print("❌ Error getting location from Firestore: $e");
      return null;
    }
  }

  /// 🔹 Calculate distance using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    double dLat = (lat2 - lat1) * pi / 180.0;
    double dLon = (lon2 - lon1) * pi / 180.0;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180.0) *
            cos(lat2 * pi / 180.0) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  /// 🔹 Fetch employees under a category and sort them based on distance or rating
  Future<List<Map<String, dynamic>>> fetchEmployeesByCategory(
      String categoryName,
      Position? currentPosition,
      String selectedFilter) async {
    try {
      QuerySnapshot categorySnapshot = await _firestore
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .get();

      if (categorySnapshot.docs.isEmpty) {
        print("⚠ No category found with name: $categoryName");
        return [];
      }

      DocumentSnapshot categoryDoc = categorySnapshot.docs.first;
      List<dynamic> workerIds = categoryDoc['workers'] ?? [];

      if (workerIds.isEmpty) {
        return [];
      }

      QuerySnapshot usersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: workerIds)
          .get();

      List<Map<String, dynamic>> employees = [];

      for (var userDoc in usersSnapshot.docs) {
        final data = userDoc.data() as Map<String, dynamic>;

        double distance = 0.0;
        double rating = 0.0;

        if (data.containsKey('rating') && data['rating'] is String) {
          rating = double.tryParse(data['rating'].toString()) ?? 0.0;
        }

        if (currentPosition != null &&
            data.containsKey('location') &&
            data['location'] is Map<String, dynamic>) {
          var location = data['location'] as Map<String, dynamic>;
          double lat = double.tryParse(location['latitude'].toString()) ?? 0.0;
          double lon = double.tryParse(location['longitude'].toString()) ?? 0.0;

          if (lat != 0.0 && lon != 0.0) {
            distance = calculateDistance(
                currentPosition.latitude, currentPosition.longitude, lat, lon);
          }
        }

        employees.add({
          'uid': userDoc.id,
          ...data,
          'distance': distance,
          'rating': rating,
        });
      }

      if (selectedFilter == "Near") {
        employees.sort((a, b) => a['distance'].compareTo(b['distance']));
      } else if (selectedFilter == "Rating") {
        employees.sort((a, b) => b['rating'].compareTo(a['rating']));
      }

      return employees;
    } catch (e) {
      print("❌ Error fetching employees: $e");
      return [];
    }
  }

//favourites_page.dart
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// 🔹 Stream to fetch favorite employees
  Stream<List<Map<String, dynamic>>> fetchFavorites() {
    final String? userId = getCurrentUserId();
    if (userId == null) {
      return Stream.error('No user is currently signed in.');
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// 🔹 Toggle favorite employee (Add/Remove)
  Future<void> toggleFavorite(String favoriteId) async {
    final String? userId = getCurrentUserId();
    if (userId == null) return;

    final favoriteRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(favoriteId);

    try {
      final doc = await favoriteRef.get();
      if (doc.exists) {
        await favoriteRef.delete(); // If exists, remove it
      }
    } catch (e) {
      print('❌ Error toggling favorite: $e');
    }
  }

//order_page.dart
  /// 🔹 Fetch name of an employee by their ID
  Future<String> getEmployeeNameById(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return userDoc['name'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print("❌ Error fetching employee name: $e");
      return 'Error';
    }
  }

  /// 🔹 Stream to fetch pending requests
  Stream<List<Map<String, dynamic>>> fetchPendingRequests() {
    final String? userId = getCurrentUserId();
    if (userId == null) {
      return Stream.error('No user is currently signed in.');
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('sentRequests')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  /// 🔹 Stream to fetch orders by status
  Stream<List<Map<String, dynamic>>> fetchOrders(String status) {
    final String? userId = getCurrentUserId();
    if (userId == null) {
      return Stream.error('No user is currently signed in.');
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  /// 🔹 Stream to fetch completed orders
  Stream<List<Map<String, dynamic>>> fetchCompletedOrders() {
    final String? userId = getCurrentUserId();
    if (userId == null) {
      return Stream.error('No user is currently signed in.');
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('completedOrders')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }

  /// 🔹 Delete a request from Firestore
  Future<void> deleteRequest({
    required String customerId,
    required String requestId,
    required String employeeId,
  }) async {
    try {
      // Delete from customer's collection
      await _firestore
          .collection('users')
          .doc(customerId)
          .collection('sentRequests')
          .doc(requestId)
          .delete();

      // Delete from employee's collection
      await _firestore
          .collection('users')
          .doc(employeeId)
          .collection('recievedRequests')
          .doc(requestId)
          .delete();

      print("✅ Request deleted successfully!");
    } catch (e) {
      print('❌ Error deleting request: $e');
      throw Exception('Failed to delete request');
    }
  }

//reviews_page.dart
  /// 🔹 Check if the user has already reviewed an order
  Future<bool> hasReviewedOrder(String employeeId, String orderId) async {
    final String? userId = getCurrentUserId();
    if (userId == null) return false;

    QuerySnapshot existingReview = await _firestore
        .collection('users')
        .doc(employeeId)
        .collection('reviews')
        .where('orderId', isEqualTo: orderId)
        .where('customerId', isEqualTo: userId)
        .get();

    return existingReview.docs.isNotEmpty;
  }

  /// 🔹 Fetch the employee's current rating and review count
  Future<Map<String, dynamic>?> getEmployeeData(String employeeId) async {
    DocumentSnapshot empDoc =
        await _firestore.collection('users').doc(employeeId).get();

    if (!empDoc.exists) return null;

    Map<String, dynamic> empData = empDoc.data() as Map<String, dynamic>? ?? {};
    return {
      'reviewsNum': int.tryParse(empData['reviewsNum']?.toString() ?? '0') ?? 0,
      'rating': double.tryParse(empData['rating']?.toString() ?? '0.0') ?? 0.0,
    };
  }

  /// 🔹 Submit a new review and update employee's rating
  Future<void> submitReview({
    required String employeeId,
    required String orderId,
    required String reviewText,
    required double rating,
  }) async {
    final String? userId = getCurrentUserId();
    if (userId == null) throw Exception('User not logged in');

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) throw Exception('User document does not exist');

    String userName = userDoc['name'] ?? 'Anonymous';

    // Fetch employee data
    final empData = await getEmployeeData(employeeId);
    if (empData == null) throw Exception('Employee not found');

    int totalReviews = empData['reviewsNum'] + 1;
    double currentRating = empData['rating'];
    double newAverageRating =
        ((currentRating * (totalReviews - 1)) + rating) / totalReviews;

    String reviewId = _firestore.collection('reviews').doc().id;

    // Submit the review
    await _firestore
        .collection('users')
        .doc(employeeId)
        .collection('reviews')
        .doc(reviewId)
        .set({
      'reviewId': reviewId,
      'customerId': userId,
      'employeeId': employeeId,
      'orderId': orderId,
      'name': userName,
      'review': reviewText.trim(),
      'rating': rating.toStringAsFixed(1),
      'date': FieldValue.serverTimestamp(),
    });

    // Update the order as reviewed
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('completedOrders')
        .doc(orderId)
        .update({'reviewed': true});

    await _firestore
        .collection('users')
        .doc(employeeId)
        .collection('completedOrders')
        .doc(orderId)
        .update({'reviewed': true});

    // Update employee's rating and review count
    await _firestore.collection('users').doc(employeeId).set(
      {
        'reviewsNum': totalReviews.toString(),
        'rating': newAverageRating.toStringAsFixed(1),
      },
      SetOptions(merge: true),
    );
  }

  //view_all_popular_categories.dart
  /// 🔹 Fetches top 5 categories with the most employees
  Future<List<Map<String, dynamic>>> fetchTopCategories() async {
    final categoriesSnapshot = await _firestore
        .collection('categories')
        .orderBy('empNum', descending: true) // Sort by most employees
        .limit(5) // Get top 5 categories
        .get();

    return categoriesSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'] ?? 'Unknown Category',
        'empNum': doc['empNum'] ?? 0,
      };
    }).toList();
  }

  //view_emp_profile_page.dart

  /// 🔹 Fetch employee data
  Future<Map<String, dynamic>?> fetchEmployeeData(String employeeId) async {
    try {
      final doc = await _firestore.collection('users').doc(employeeId).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      print('Error fetching employee data: $e');
    }
    return null;
  }

  final String? loggedInUserId = FirebaseAuth.instance.currentUser?.uid;

  /// 🔹 Check if employee is favorited
  Future<bool> isFavorite(String employeeId) async {
    try {
      if (loggedInUserId == null) return false;
      final doc = await _firestore
          .collection('users')
          .doc(loggedInUserId)
          .collection('favourites')
          .doc(employeeId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  /// 🔹 Toggle favorite status
  Future<void> toggleFavoriteEmp(String employeeId, bool isFavorite,
      Map<String, dynamic>? employeeData) async {
    try {
      if (loggedInUserId == null) return;

      final favoritesCollection = _firestore
          .collection('users')
          .doc(loggedInUserId)
          .collection('favourites');

      if (isFavorite) {
        await favoritesCollection.doc(employeeId).delete();
      } else {
        await favoritesCollection.doc(employeeId).set({
          'uid': employeeId,
          'name': employeeData?['name'] ?? 'Unnamed',
          'img': employeeData?['img'] ?? '',
          'location': employeeData?['location'] ?? 'Unknown',
          'rating': employeeData?['rating'] ?? 0,
        });
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  /// 🔹 Send a request to an employee
  Future<bool> sendRequest(
      String employeeId, String name, String description) async {
    try {
      if (loggedInUserId == null) return false;

      final String requestId = _firestore.collection('dummy').doc().id;

      final requestData = {
        'requestId': requestId,
        'senderId': loggedInUserId,
        'receiverId': employeeId,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
        'name': name,
      };

      await _firestore
          .collection('users')
          .doc(loggedInUserId)
          .collection('sentRequests')
          .doc(requestId)
          .set(requestData);
      await _firestore
          .collection('users')
          .doc(employeeId)
          .collection('recievedRequests')
          .doc(requestId)
          .set(requestData);

      return true;
    } catch (e) {
      print('Error sending request: $e');
      return false;
    }
  }
}
