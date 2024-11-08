import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/route/api_paths.dart';
import 'package:hire_harmony/views/widgets/admin/adn_card.dart';

part 'adnhome_state.dart';

class AdnHomeCubit extends Cubit<AdnHomeState> {
  AdnHomeCubit() : super(AdnHomeInitial());

  final FirestoreService _firestore = FirestoreService.instance;

  Future<void> loadData() async {
    final uid =
        FirebaseAuth.instance.currentUser?.uid; // Get the current user's UID

    if (uid == null) {
      emit(AdnHomeError("No user is currently logged in."));
      return;
    }

    emit(AdnHomeLoading()); // Start loading

    _firestore
        .collectionStream<ControlCard>(
      path: ApiPaths.controlCard(
          uid), // Directly referencing the ControlCards collection
      builder: (data, documentId) => ControlCard.fromMap(data),
    )
        .listen((controlCards) {
      emit(AdnHomeLoaded(controlCards)); // Emit loaded state with control cards
    }, onError: (error) {
      emit(AdnHomeError("Failed to load control cards: $error"));
    });
  }
}
