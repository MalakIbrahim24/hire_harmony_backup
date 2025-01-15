import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class NewAccountsRequestsPage extends StatefulWidget {
  const NewAccountsRequestsPage({super.key});

  @override
  State<NewAccountsRequestsPage> createState() =>
      _NewAccountsRequestsPageState();
}

class _NewAccountsRequestsPageState extends State<NewAccountsRequestsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to fetch users with role "employee" and state "pending"
  Stream<QuerySnapshot> _fetchPendingEmployees() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .where('state', isEqualTo: 'pending')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Employee Requests"),
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
              child: Text("No pending employee requests."),
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
                  subtitle: Text(user['email']),
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
                        backgroundColor:
                            AppColors().navy, // Set the button color to blue
                        padding: const EdgeInsets.symmetric(
                            vertical: 8), // Adjust vertical padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Add rounded corners
                        ),
                      ),
                      child: Text(
                        "View Request",
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 12,
                          color: Colors.white, // Text color
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

  Future<void> _approveEmployee(BuildContext context) async {
    
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id) // Use document ID to locate the user
          .update({'state': 'approved'}); // Update state to approved
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee approved successfully!")),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Go back to the previous page
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error approving employee: $e")),
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
                      onPressed: () => _approveEmployee(context),
                      child: const Text("Approve"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle reject logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Reject"),
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
