import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/services/employee_services.dart';
import 'package:hire_harmony/views/pages/employee/add_advertisement_page.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/widgets/employee/advertisement_card.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({super.key});

  @override
  State<AdvertisementScreen> createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EmployeeService employeeService = EmployeeService(); // استدعاء `EmployeeService`

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Advertisements"),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .doc(_auth.currentUser?.uid)
              .collection('advertisements')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No advertisements yet. Add one!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            }

            final advertisements = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: advertisements.length,
              itemBuilder: (context, index) {
                final ad = advertisements[index].data() as Map<String, dynamic>;
                final adId = advertisements[index].id; // الحصول على معرّف الإعلان من Firestore

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: AdvertisementCard(
                    image: ad['image'] ?? '',
                    title: ad['name'] ?? '',
                    description: ad['description'] ?? '',
                    onDelete: () => employeeService.confirmDeleteAdvertisement(context, adId), // ✅ استدعاء الدالة من EmployeeService
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors().orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAdvertisementPage(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
