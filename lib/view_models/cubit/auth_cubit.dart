
import 'package:bloc/bloc.dart';
import 'package:hire_harmony/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hire_harmony/services/firestore_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServices authServices = AuthServicesImpl();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _fireS = FirestoreService.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());
    try {
      final result =
          await authServices.signInWithEmailAndPassword(email, password);

      if (result) {
        final user = await authServices.currentUser();
        // Fetch the user role using the method within this cubit
        if (user != null) {
          String role = await _fireS.getUserRoleByUid(user.uid);

          // Emit the appropriate success state based on the role
          if (role == "admin") {
            emit(AuthSuccess());
          } else if (role == "customer") {
            emit(AuthCusSuccess());
          } else if (role == "employee") {
            emit(AuthEmpSuccess());
          } else {
            // Handle unexpected roles or lack of role data
            emit(AuthFailure("Role not recognized or missing."));
          }
        }
      } else {
        emit(AuthFailure('Failed to log in'));
      }
    } catch (e) {
      // Ensure that any errors are caught, and a failure state is emitted
      emit(AuthFailure("An error occurred: ${e.toString()}"));
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store the user role in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role, // Add the role (e.g., "customer", "employee", "admin")
      });
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Future<void> cusSignInWithEmailAndPassword(
  //     String email, String password) async {
  //   emit(AuthLoading());
  //   try {
  //     final result =
  //         await authServices.cusSignInWithEmailAndPassword(email, password);
  //     if (result) {
  //       emit(AuthCusSuccess());
  //     } else {
  //       emit(AuthFailure('Failed to  sign in'));
  //     }
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }

  // Future<void> empSignInWithEmailAndPassword(
  //     String email, String password) async {
  //   emit(AuthLoading());
  //   try {
  //     final result =
  //         await authServices.empSignInWithEmailAndPassword(email, password);
  //     if (result) {
  //       emit(AuthEmpSuccess());
  //     } else {
  //       emit(AuthFailure('Failed to  sign in'));
  //     }
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await authServices.signOut();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Future<void> getCurrentUser() async {
  //   emit(AuthLoading());
  //   try {
  //     final user = await authServices.currentUser();
  //     if (user != null) {
  //       emit(AuthSuccess());
  //     } else {
  //       emit(AuthInitial());
  //     }
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }

  // Future<void> getCurrentUser() async {
  //   emit(AuthLoading());
  //   try {
  //     final user = await authServices.currentUser();
  //     final signIn = await authServices.isSignIn();
  //     log('$user');
  //     if (signIn) {
  //       String role = await _fireS.getUserRoleByUid(user!.uid);
  //       log(role);
  //       if (role == 'admin') {
  //         emit(AuthSuccess());
  //       } else if (role == 'customer') {
  //         emit(AuthCusSuccess());
  //       } else if (role == 'employee') {
  //         emit(AuthEmpSuccess());
  //       }
  //     } else {
  //       emit(AuthInitial());
  //     }
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }

  // Fetch the role of the user
}
