import 'package:firebase_auth/firebase_auth.dart';
import 'package:hire_harmony/models/user_data.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/route/api_paths.dart';

class UserServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestoreService = FirestoreService.instance;

  // Get user
  Future<UserData> getUser() async {
    final user = _firebaseAuth.currentUser;

    final userData = await _firestoreService.getDocument(
      path: ApiPaths.user(user!.uid),
      builder: (data, documentId) => UserData.fromMap(data),
    // Corrected here
    );
    return userData;

  }
}
