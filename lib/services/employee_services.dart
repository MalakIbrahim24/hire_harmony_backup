import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_harmony/api/firebase_api.dart';
import 'package:hire_harmony/views/pages/location_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  // ✅ دالة لجلب بيانات المستخدم مرة واحدة فقط
  Future<Map<String, dynamic>> fetchEmployeeData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return {};

      final DocumentSnapshot employeeDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (!employeeDoc.exists) return {};

      final data = employeeDoc.data() as Map<String, dynamic>;
      return {
        'name': data['name'] ?? 'User',
        'profileImageUrl': data['img'] ?? '',
        'location': data['Address'] ?? 'Unknown Location',
      };
    } catch (e) {
      debugPrint('❌ Error fetching employee data: $e');
      return {};
    }
  }

  // ✅ دالة جلب حالة توفر العامل
  Future<bool> fetchEmployeeAvailability() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return false;

      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      return userDoc['availability'] ?? true;
    } catch (e) {
      debugPrint('❌ Error fetching employee availability: $e');
      return true;
    }
  }

  // ✅ دالة لمراقبة الطلبات المعلقة عبر `Stream`
  Stream<int> fetchPendingRequests() {
    final User? user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('recievedRequests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // ✅ التأكد من أن المستخدم حدد موقعه
  Future<void> checkUserLocation() async {
    await Future.delayed(const Duration(seconds: 10)); // الانتظار لمدة 10 ثوانٍ

    final employeeId = _auth.currentUser?.uid;
    if (employeeId == null) return;

    final isLocationSaved = await FirebaseApi().isUserLocationSaved(employeeId);

    if (!isLocationSaved) {
      await Get.to(() => const LocationPage());
    }
  }

   // ✅ دالة لحذف الإعلان
  Future<void> deleteAdvertisement(BuildContext context, String adId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('advertisements')
          .doc(adId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Advertisement deleted successfully."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Error deleting advertisement: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to delete advertisement."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ دالة تأكيد الحذف (تم نقلها من `AdvertisementScreen`)
  void confirmDeleteAdvertisement(BuildContext context, String adId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // استخدم dialogContext داخل showDialog
        return AlertDialog(
          title:  Text("Confirm Delete",
           style: TextStyle(
                color:  Theme.of(context).colorScheme.primary,

              ),
          ),
          content:  Text(
              "Are you sure you want to delete this advertisement? This action cannot be undone."
              , 
              style: TextStyle(
                color:  Theme.of(context).colorScheme.primary,

              ),
              ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // إغلاق نافذة التأكيد
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // إغلاق نافذة التأكيد قبل الحذف
                await deleteAdvertisement(context, adId); // استدعاء الحذف
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  // ✅ دالة لاختيار الصورة من المعرض
  Future<File?> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  // ✅ دالة لرفع الإعلان مع الصورة
  Future<void> uploadAdvertisement(
      BuildContext context, File? selectedImage, String title, String description) async {
    if (selectedImage == null || title.isEmpty || description.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please fill all fields and select an image.')),
        );
      }
      return;
    }

    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${selectedImage.path.split('/').last}';

      // ✅ رفع الصورة إلى Supabase
      final String filePath = await supabase.Supabase.instance.client.storage
          .from('serviceImages')
          .upload('advertisements/$fileName', selectedImage);

      // ✅ الحصول على رابط الصورة
      final imageUrl = supabase.Supabase.instance.client.storage
          .from('serviceImages')
          .getPublicUrl(filePath.replaceFirst('serviceImages/', ''));

      // ✅ حفظ بيانات الإعلان في Firestore
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('advertisements')
            .add({
          'name': title,
          'description': description,
          'image': imageUrl,
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Advertisement added successfully!')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('❌ Error uploading advertisement: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload advertisement.')),
        );
      }
    }
  }
   

     Future<void> deleteItem(BuildContext context, String itemId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('items')
          .doc(itemId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Item deleted successfully."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Error deleting item: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to delete item."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// ✅ **دالة لتأكيد الحذف**
  void confirmDeleteItem(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text(
              "Are you sure you want to delete this item? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // إلغاء
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الـ Dialog
                deleteItem(context, itemId); // ✅ حذف العنصر بعد التأكيد
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }



  /// ✅ **دالة لجلب اسم المستخدم مع التخزين المؤقت لتقليل القراءة من Firestore**
  Future<String> fetchUserName() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // ✅ **إذا كان الاسم مخزنًا محليًا، استخدمه مباشرة دون Firestore**
      String? cachedUserName = prefs.getString('userName');
      if (cachedUserName != null) {
        debugPrint("✅ Loaded username from cache: $cachedUserName");
        return cachedUserName;
      }

      // ✅ **إذا لم يكن الاسم مخزنًا، اجلبه من Firestore وخزنه محليًا**
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String userName = userDoc['name'] ?? "User";

          // ✅ **تخزين الاسم محليًا لتجنب استدعاءات Firestore المتكررة**
          await prefs.setString('userName', userName);
          debugPrint("✅ Stored username in cache: $userName");

          return userName;
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching user name: $e");
    }
    return "User"; // ✅ القيمة الافتراضية عند حدوث خطأ
  }

 /// ✅ **دالة لتحديث عدد الطلبات المكتملة فقط عند الحاجة**
  Future<void> updateCompletedOrdersCount(String workerId) async {
    final workerRef = _firestore.collection('users').doc(workerId);
    final prefs = await SharedPreferences.getInstance();

    // 🔹 التحقق من العدد المخزن محليًا لتجنب التحديث غير الضروري
    int? cachedCount = prefs.getInt('completedOrdersCount_$workerId');

    // 🔹 جلب العدد الفعلي فقط عند الحاجة
    final completedOrdersSnapshot =
        await workerRef.collection('completedOrders').get();
    int completedOrdersCount = completedOrdersSnapshot.size;

    // ✅ تحديث Firestore فقط إذا كان العدد مختلفًا عن المخزن محليًا
    if (cachedCount == null || cachedCount != completedOrdersCount) {
      await workerRef.update({'completedOrdersCount': completedOrdersCount});
      await prefs.setInt('completedOrdersCount_$workerId', completedOrdersCount);
      debugPrint("✅ Updated completedOrdersCount to: $completedOrdersCount");
    } else {
      debugPrint("✅ Skipping update, no change in completedOrdersCount.");
    }
  }

  /// ✅ **دالة لاكمال الطلب باستخدام `batch write` لتقليل عمليات الكتابة**
  Future<void> markOrderAsCompleted(
      BuildContext context,
      String orderId,
      String customerId,
      String employeeId,
      Map<String, dynamic> orderData) async {
    try {
      final batch = _firestore.batch();

      final customerOrderRef = _firestore
          .collection('users')
          .doc(customerId)
          .collection('completedOrders')
          .doc(orderId);

      final employeeOrderRef = _firestore
          .collection('users')
          .doc(employeeId)
          .collection('completedOrders')
          .doc(orderId);

      final customerOrderDeleteRef = _firestore
          .collection('users')
          .doc(customerId)
          .collection('orders')
          .doc(orderId);

      final employeeOrderDeleteRef = _firestore
          .collection('users')
          .doc(employeeId)
          .collection('orders')
          .doc(orderId);

      // ✅ إضافة الطلب إلى `completedOrders` لكلا الطرفين
      batch.set(customerOrderRef, {...orderData, 'status': 'completed'});
      batch.set(employeeOrderRef, {...orderData, 'status': 'completed'});

      // ✅ حذف الطلب من `orders`
      batch.delete(customerOrderDeleteRef);
      batch.delete(employeeOrderDeleteRef);

      // ✅ تحديث `chatController` فقط إذا لم يكن مغلقًا بالفعل
      final chatId = employeeId.compareTo(customerId) < 0
          ? '${employeeId}_$customerId'
          : '${customerId}_$employeeId';

      final chatRef = _firestore.collection('chat_rooms').doc(chatId);
      final chatSnapshot = await chatRef.get();
      if (chatSnapshot.exists &&
          chatSnapshot.data()?['chatController'] != 'closed') {
        batch.update(chatRef, {'chatController': 'closed'});
      }

      // 🔹 تنفيذ جميع العمليات في مرة واحدة
      await batch.commit();

      // ✅ تحديث عدد الطلبات المكتملة محليًا وفقط إذا تغير العدد
      await updateCompletedOrdersCount(employeeId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order marked as completed.'),
            backgroundColor: Colors.green,
          ),
        );
      }
      debugPrint('✅ Order marked as completed and batch operation committed.');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint("❌ Error marking order as completed: $e");
    }
  }
  // ✅ Fetch orders based on status (in progress / completed)
Stream<List<Map<String, dynamic>>> fetchOrders(String userId, String status) {
  return _firestore
      .collection('users')
      .doc(userId)
      .collection(status == 'completed' ? 'completedOrders' : 'orders')
      .snapshots()
      .asyncMap((querySnapshot) async {
    List<Map<String, dynamic>> orders = [];

    for (var doc in querySnapshot.docs) {
      final orderData = doc.data();
      final senderId = orderData['senderId'];

      // 🔹 جلب بيانات العميل
      final senderDoc =
          await _firestore.collection('users').doc(senderId).get();
      final senderData = senderDoc.data();

      orders.add({
        'id': doc.id,
        'name': orderData['name'] ?? 'Unknown Order',
        'orderId': orderData['orderId'] ?? '',
        'status': orderData['status'] ?? 'unknown',
        'confirmedTime': (orderData['confirmedTime'] as Timestamp?)?.toDate() ??
            DateTime.now(),
        'customerImage': senderData?['img'] ??
            'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg',
        'senderId': senderId,
      });
    }
    return orders;
  });
}

// ✅ Show order dialog for confirmation
void showOrderDialog(BuildContext context, String orderId, String customerId,
    String employeeId, Map<String, dynamic> orderData) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Order Options'),
        content: const Text(
            'Would you like to mark this order as completed or cancel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              confirmCompletion(
                  context, orderId, customerId, employeeId, orderData);
            },
            child: const Text('Completed'),
          ),
        ],
      );
    },
  );
}

// ✅ Confirm order completion
void confirmCompletion(BuildContext context, String orderId, String customerId,
    String employeeId, Map<String, dynamic> orderData) {
  showDialog(
    context: context,
    builder: (confirmDialogContext) {
      return AlertDialog(
        title: const Text('Confirm Completion'),
        content: const Text(
            'Are you sure you want to mark this order as completed? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(confirmDialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(confirmDialogContext); // Close confirmation dialog
              markOrderAsCompleted(context, orderId, customerId, employeeId,
                  orderData); // ✅ Call markOrderAsCompleted
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
}


 Future<Map<String, dynamic>?> ProfilefetchEmployeeData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return null;

      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        return {
          'name': doc['name'] ?? '',
          'img': doc['img'] ?? '',
        };
      }
    } catch (e) {
      print('Error fetching employee data: $e');
    }
    return null;
  }

  Future<void> saveProfileUpdates({
    required String name,
    String? imagePath,
    String? newPassword,
    String? confirmPassword,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      final Map<String, dynamic> updates = {};
      if (name.isNotEmpty) updates['name'] = name;

      if (imagePath != null) {
        final String? uploadedImageUrl = await _uploadImageToSupabase(imagePath);
        if (uploadedImageUrl != null) {
          updates['img'] = uploadedImageUrl;
        }
      }

      if (newPassword != null && confirmPassword != null) {
        if (newPassword == confirmPassword) {
          await _updatePassword(user.uid, newPassword);
        } else {
          throw Exception("Passwords do not match");
        }
      }


      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
      }
    } catch (e) {
      print("Error updating profile: $e");
      throw Exception("Failed to update profile");
    }
  }

  Future<void> _updatePassword(String userId, String newPassword) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return;

      await user.updatePassword(newPassword);
      final String salt = _generateSalt();
      final String hashedPassword = _hashPassword(newPassword, salt);

      await _firestore.collection('users').doc(userId).update({
        'passwordHash': hashedPassword,
        'salt': salt,
      });
    } catch (e) {
      print("Error updating password: $e");
      throw Exception("Failed to update password");
    }
  }

  String _generateSalt() {
    final Random random = Random.secure();
    final List<int> saltBytes = List.generate(16, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  String _hashPassword(String password, String salt) {
    final List<int> bytes = utf8.encode(salt + password);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String?> _uploadImageToSupabase(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

      final String filePath = await supabase.Supabase.instance.client.storage
          .from('serviceImages')
          .upload('profile/$fileName', imageFile);

      return supabase.Supabase.instance.client.storage
          .from('serviceImages')
          .getPublicUrl(filePath.replaceFirst('serviceImages/', ''));
    } catch (e) {
      print('Supabase upload error: $e');
      return null;
    }
  }
    Future<void> submitComplaint({
    required BuildContext context,
    required TextEditingController messageController,
    required String? adminId,
  }) async {
    final message = messageController.text.trim();
    if (message.isEmpty) {
      _showSnackbar(context, 'Please enter a message before submitting.');
      return;
    }

    final String? currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) {
      _showSnackbar(context, 'User not logged in!');
      return;
    }

    if (adminId == null) {
      _showSnackbar(context, 'Admin ID not found. Cannot send complaint.');
      return;
    }

    try {
      final DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();
      final String name = userSnapshot['name'];

      await _firestore.collection('users').doc(adminId).collection('complaints').add({
        'userId': currentUserId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'name': name,
      });

      messageController.clear();
      _showSnackbar(context, 'Complaint sent successfully!');
    } catch (e) {
      _showSnackbar(context, 'Error sending complaint: $e');
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  Future<void> uploadItem({
    required BuildContext context,
    required File? selectedImage,
    required String title,
    required String description,
  }) async {
    if (selectedImage == null || title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image.')),
      );
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in!')),
        );
        return;
      }

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${selectedImage.path.split('/').last}';

      // ✅ رفع الصورة إلى Supabase
      final String filePath = await supabase.Supabase.instance.client.storage
          .from('serviceImages')
          .upload('items/$fileName', selectedImage);

      // ✅ جلب رابط الصورة
      final String imageUrl = supabase.Supabase.instance.client.storage
          .from('serviceImages')
          .getPublicUrl(filePath.replaceFirst('serviceImages/', ''));

      // ✅ إنشاء Batch للكتابة إلى Firestore
      WriteBatch batch = _firestore.batch();

      final itemRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('items')
          .doc(); // 🔹 إنشاء `ID` مسبقًا

      batch.set(itemRef, {
        'name': title.trim(),
        'description': description.trim(),
        'image': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // ✅ تنفيذ جميع العمليات دفعة واحدة
      await batch.commit();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('❌ Error uploading item: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload item: $e')),
        );
      }
    }
  }
}




