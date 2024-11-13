import 'package:firebase_auth/firebase_auth.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/route/api_paths.dart';

abstract class AuthServices {
  Future<bool> signInWithEmailAndPassword(String email, String password);
  Future<bool> cusSignInWithEmailAndPassword(String email, String password);
  Future<bool> empSignInWithEmailAndPassword(String email, String password);

  Future<bool> signUpWithEmailAndPassword(String email, String password);

  Future<void> signOut();
  Future<User?> currentUser();
  Future<bool> isSignIn();
}

class AuthServicesImpl implements AuthServices {
  // singleton design pattern

  final firebaseAuth = FirebaseAuth.instance;
  final firestoreService = FirestoreService.instance;

  @override
  Future<bool> isSignIn() async {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    User? user = userCredential.user;

    if (user != null) {
      return true;
    }

    return false;
  }

  @override
  Future<void> signOut() async {
    firebaseAuth.signOut();
  }

  @override
  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    User? user = userCredential.user;
    if (user != null) {
      await firestoreService.setData(path: ApiPaths.user(user.uid), data: {
        'email': user.email,
        'uid': user.uid,
        'name': user.displayName,
        'phone': user.phoneNumber,
        'photoUrl': user.photoURL,
      });
      return true;
    }
    return false;
  }

  @override
  Future<User?> currentUser() async {
    return Future.value(firebaseAuth.currentUser);
  }

  @override
  Future<bool> cusSignInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    User? user = userCredential.user;

    if (user != null) {
      return true;
    }

    return false;
  }

  @override
  Future<bool> empSignInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    User? user = userCredential.user;

    if (user != null) {
      return true;
    }

    return false;
  }
}
