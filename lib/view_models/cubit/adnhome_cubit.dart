import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hire_harmony/models/service.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/route/api_paths.dart';
import 'package:hire_harmony/views/widgets/admin/adn_card.dart';
part 'adnhome_state.dart';

class AdnHomeCubit extends Cubit<AdnHomeState> {
  AdnHomeCubit() : super(AdnHomeInitial());

  final FirestoreService _firestore = FirestoreService.instance;

  /// Load Control Cards Data
  Future<void> loadData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      emit(AdnHomeError("No user is currently logged in."));
      return;
    }

    emit(AdnHomeLoading());

    _firestore
        .collectionStream<ControlCard>(
      path: ApiPaths.controlCard(uid),
      builder: (data, documentId) => ControlCard.fromMap(data),
    )
        .listen((controlCards) {
      emit(AdnHomeLoaded(controlCards, unreadNotificationsCount: 0));
    }, onError: (error) {
      emit(AdnHomeError("Failed to load control cards: $error"));
    });
  }

  /// Load Notifications & Control Cards
Future<void> loadNotifications() async {
  try {
    emit(AdnHomeLoading());

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(AdnHomeError("No user logged in."));
      return;
    }

    // Fetch notifications for the user
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();

    // Map notifications to a List of ControlCards (or use a different model if needed)
    final notifications = snapshot.docs.map((doc) {
      return ControlCard.fromMap({
        'id': doc.id,
        'name': doc['title'] ?? 'No Title', // Adjust field mapping if necessary
        'description': doc['body'] ?? '',
      });
    }).toList();

    // Count unread notifications
    int unreadCount = snapshot.docs.where((n) => n['read'] == false).length;

    emit(AdnHomeLoaded(notifications, unreadNotificationsCount: unreadCount));
  } catch (e) {
    emit(AdnHomeError("Failed to load notifications: $e"));
  }
}




  void resetNotificationCount(List<ControlCard> controlCards) {
    emit(AdnHomeLoaded(controlCards, unreadNotificationsCount: 0));
  }

 Future<void> resetUnreadNotifications() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return;

  try {
    // Update all notifications' read status to true in Firestore
    final batch = FirebaseFirestore.instance.batch();

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }

    await batch.commit();

    // Emit state with 0 unread notifications
    emit(AdnHomeLoaded([], unreadNotificationsCount: 0));
  } catch (e) {
    emit(AdnHomeError("Failed to reset notifications: $e"));
  }
}


  /// Add a New Service
  Future<void> addService(Service service) async {
    try {
      await _firestore.addData(
        collectionPath: 'services',
        data: service.toMap(),
      );
      emit(AdnHomeSuccess("Service added successfully!"));
    } catch (e) {
      emit(AdnHomeError("Failed to add service: $e"));
    }
  }

  /// Edit an Existing Service
  Future<void> editService(Service service) async {
    try {
      await _firestore.updateData(
        documentPath: 'services/${service.id}',
        data: service.toMap(),
      );
      emit(AdnHomeSuccess("Service updated successfully!"));
    } catch (e) {
      emit(AdnHomeError("Failed to update service: $e"));
    }
  }

  /// Delete a Service
  Future<void> deleteService(String serviceId) async {
    try {
      await _firestore.deleteData(
        documentPath: 'services/$serviceId',
      );
      emit(AdnHomeSuccess("Service deleted successfully!"));
    } catch (e) {
      emit(AdnHomeError("Failed to delete service: $e"));
    }
  }
}
