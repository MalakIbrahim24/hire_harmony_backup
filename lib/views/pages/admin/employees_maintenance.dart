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

  Stream<QuerySnapshot> _fetchPendingEmployees() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Employee Maintenance",
          style: GoogleFonts.montserratAlternates(
            color: AppColors().navy,
            fontSize: 18,
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

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final user = docs[index];
              final userData = user.data() as Map<String, dynamic>?;
              if (userData == null) return const SizedBox();

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: userData.containsKey('img')
                        ? NetworkImage(userData['img'])
                        : null,
                  ),
                  title: Text(userData.containsKey('name')
                      ? userData['name']
                      : 'Unknown'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userData.containsKey('email')
                          ? userData['email']
                          : 'No email'),
                      if (userData.containsKey('similarity') &&
                          userData['similarity'] != null)
                        Text(
                          'Similarity: ${double.tryParse(userData['similarity'].toString())?.toStringAsFixed(3) ?? '0.000'}%',
                          style: TextStyle(
                            color: (double.tryParse(userData['similarity']
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
                    width: 100,
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

class EndorseEmployeePage extends StatefulWidget {
  final DocumentSnapshot user;

  const EndorseEmployeePage({super.key, required this.user});

  @override
  State<EndorseEmployeePage> createState() => _EndorseEmployeePageState();
}

class _EndorseEmployeePageState extends State<EndorseEmployeePage> {
  late String currentState;

  @override
  void initState() {
    super.initState();
    currentState = widget.user['state']; // Initialize the state from Firestore
  }

  Future<void> _toggleEmployeeState(BuildContext context) async {
    try {
      final newState = currentState == 'accepted' ? 'pending' : 'accepted';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.id) // Use document ID to locate the user
          .update({'state': newState}); // Toggle the state

      setState(() {
        currentState = newState; // Update the local state
      });
      if (!mounted) return;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentState == 'pending'
                  ? "Employee suspended for now!"
                  : "Employee reinstated successfully!",
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating employee state: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user['name']),
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
                    backgroundImage: NetworkImage(widget.user['img']),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Name: ${widget.user['name']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Email: ${widget.user['email']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Phone: ${widget.user['phone']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Role: ${widget.user['role']}",
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
                    widget.user['selfieImageUrl'], // Fetch selfie image URL
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
                    widget.user['idImageUrl'], // Fetch ID image URL
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _toggleEmployeeState(context); // Toggle state
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors().navy,
                      ),
                      child: Text(
                        currentState == 'accepted' ? "Defer" : "Unlock",
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
