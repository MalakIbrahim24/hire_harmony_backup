import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart'; // For easier state comparisons in Bloc/Cubit.
//ready
part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EmployeeCubit() : super(EmployeeLoading());

  Future<void> fetchEmployeeData() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        emit(EmployeeError("User not logged in."));
        return;
      }

      final DocumentSnapshot employeeDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (employeeDoc.exists) {
        final data = employeeDoc.data() as Map<String, dynamic>;

        emit(EmployeeLoaded(
          id: data['uid'] ?? user.uid,
          name: data['name'] ?? 'Unknown Name',
          location: data['Address'] ?? 'Unknown Location',
          profileImageUrl: data['img'] ?? 'https://via.placeholder.com/150',
          aboutMe: data['about'] ?? 'No description available.',
          rating: data['rating']?.toString() ?? '0.0',
          services: List<String>.from(data['services'] ?? []),
          isAvailable: data['availability'] ?? true,
          reviewsNum: data['reviews'] ?? 0,
        ));
      } else {
        emit(EmployeeError("No data found."));
      }
    } catch (e) {
      emit(EmployeeError("Error fetching data: $e"));
    }
  }

  Future<void> updateAvailability(bool value) async {
    if (state is EmployeeLoaded) {
      try {
        final User? user = _auth.currentUser;
        if (user == null) return;

        await _firestore.collection('users').doc(user.uid).update({
          'availability': value,
        });

        emit((state as EmployeeLoaded).copyWith(isAvailable: value));
      } catch (e) {
        emit(EmployeeError("Error updating availability: $e"));
      }
    }
  }

  Future<void> updateAboutMe(String about) async {
    if (state is EmployeeLoaded) {
      try {
        final User? user = _auth.currentUser;
        if (user == null) return;

        await _firestore.collection('users').doc(user.uid).update({
          'about': about,
        });

        emit((state as EmployeeLoaded).copyWith(aboutMe: about));
      } catch (e) {
        emit(EmployeeError("Error updating About Me: $e"));
      }
    }
  }

  Future<void> updateLocation(String location) async {
    if (state is EmployeeLoaded) {
      try {
        final User? user = _auth.currentUser;
        if (user == null) return;

        await _firestore.collection('users').doc(user.uid).set({
          'Address': location,
        }, SetOptions(merge: true));

        emit((state as EmployeeLoaded).copyWith(location: location));
      } catch (e) {
        emit(EmployeeError("Error updating location: $e"));
      }
    }
  }

  Future<void> addService(String service) async {
    if (state is EmployeeLoaded) {
      final User? user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'services': FieldValue.arrayUnion([service]),
      });

      final updatedServices =
          List<String>.from((state as EmployeeLoaded).services)..add(service);

      emit((state as EmployeeLoaded).copyWith(services: updatedServices));

      // تحديث عدد الخدمات في bestworker
      // await _firestore.collection('bestworker').doc(user.uid).update({
      //   'servNum': updatedServices.length.toString(),
      // }
      
      // );
    }
  }

  Future<void> removeService(String service) async {
    if (state is EmployeeLoaded) {
      final User? user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'services': FieldValue.arrayRemove([service]),
      });

      final updatedServices =
          List<String>.from((state as EmployeeLoaded).services)
            ..remove(service);

      emit((state as EmployeeLoaded).copyWith(services: updatedServices));

      // تحديث عدد الخدمات في bestworker
     // await _firestore.collection('bestworker').doc(user.uid).update({
      //  'servNum': updatedServices.length.toString(),
     // });
    }
  }
}
