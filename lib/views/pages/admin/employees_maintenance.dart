import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class EmployeesMaintenance extends StatefulWidget {
  const EmployeesMaintenance({super.key});

  @override
  State<EmployeesMaintenance> createState() => _NewAccountsRequestsPageState();
}

class _NewAccountsRequestsPageState extends State<EmployeesMaintenance> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to fetch users with role "employee" and state "pending"
  Stream<QuerySnapshot> _fetchPendingEmployees() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .where('state', isEqualTo: 'accepted')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Employee Maintenance",
          style: GoogleFonts.montserratAlternates(
            color: AppColors().white,
            fontSize: 15,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchPendingEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching data."),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No registered employees."),
            );
          }

          // Extract documents from the snapshot
          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final user = docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['img']),
                  ),
                  title: Text(user['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['email']),
                      if (user['similarity'] != null)
                        Text(
                          'Similarity: ${user['similarity'].toString()}%',
                          style: TextStyle(
                            color: (user['similarity'] is int
                                        ? user['similarity']
                                        : double.tryParse(user['similarity']
                                                .toString()) ??
                                            0) <
                                    80
                                ? AppColors().orange
                                : AppColors().green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100, // Set the desired width of the button
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EndorseEmployeePage(user: user),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().navy,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "View employee",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// EndorseEmployeePage for detailed view
class EndorseEmployeePage extends StatelessWidget {
  final DocumentSnapshot user;

  const EndorseEmployeePage({super.key, required this.user});

  Future<void> _deferEmployee(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id) // Use document ID to locate the user
          .update({'state': 'pending'}); // Update state to approved
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee suspended for now!")),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Go back to the previous page
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error suspending employee: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user['img']),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Name: ${user['name']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Email: ${user['email']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Phone: ${user['phone']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Role: ${user['role']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Selfie Image:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Image.network(
                    user['selfieImageUrl'], // Fetch selfie image URL
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "ID Image:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Image.network(
                    user['idImageUrl'], // Fetch ID image URL
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _deferEmployee(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().navy,
                      ),
                      child: Text(
                        "Defer",
                        style: GoogleFonts.montserratAlternates(
                          color: AppColors().white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
