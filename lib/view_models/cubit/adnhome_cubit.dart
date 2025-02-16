import 'package:bloc/bloc.dart';
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
