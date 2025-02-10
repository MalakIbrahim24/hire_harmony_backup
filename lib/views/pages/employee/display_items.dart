import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hire_harmony/services/employee_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:hire_harmony/views/pages/employee/add_item.dart';
import 'package:hire_harmony/views/widgets/employee/advertisement_card.dart';
import 'package:hire_harmony/views/widgets/shimmer_page.dart';

class DisplayItems extends StatefulWidget {
  const DisplayItems({super.key});

  @override
  State<DisplayItems> createState() => _DisplayItemsState();
}

class _DisplayItemsState extends State<DisplayItems> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final EmployeeService employeeService = EmployeeService(); // ✅ استدعاء `EmployeeService`

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Items",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
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
              .collection('items')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShimmerPage();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No items yet. Add one!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            }

            final items = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final itemData = items[index].data() as Map<String, dynamic>;
                final itemId = items[index].id; // ✅ جلب `itemId`

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: AdvertisementCard(
                    image: itemData['image'] ?? '',
                    title: itemData['name'] ?? '',
                    description: itemData['description'] ?? '',
                    onDelete: () =>
                       EmployeeService.instance.confirmDeleteItem(context, itemId), // ✅ استخدام `confirmDelete`
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
              builder: (context) => const AddItem(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

