import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Management',
          style: GoogleFonts.montserratAlternates(
            color: AppColors().white,
          ),
        ),
        backgroundColor: AppColors().navy,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors().white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Users',
                labelStyle: GoogleFonts.montserratAlternates(
                  color: AppColors().navy,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors().navy),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService.instance.collectionStream(
                path: 'users',
                builder: (data, documentId) => {
                  'id': documentId,
                  'name': data['name'] ?? 'Unnamed',
                  'email': data['email'] ?? 'No email',
                },
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.montserratAlternates(
                        color: AppColors().navy,
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No users found',
                      style: GoogleFonts.montserratAlternates(
                        color: AppColors().navy,
                      ),
                    ),
                  );
                }

                final users = snapshot.data!
                    .where((user) => user['name']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery))
                    .toList();

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors().navy.withOpacity(0.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          user['name'],
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors().navy,
                          ),
                        ),
                        subtitle: Text(
                          user['email'],
                          style: GoogleFonts.montserratAlternates(
                            fontSize: 14,
                            color: AppColors().navy,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: AppColors().red),
                          onPressed: () async {
                            // First Confirmation Dialog
                            final confirm1 = await _showConfirmationDialog(
                              context,
                              title: 'Delete User',
                              content:
                                  'Are you sure you want to delete this user?',
                            );

                            if (confirm1 == true) {
                              // Second Confirmation Dialog
                              final confirm2 = await _showConfirmationDialog(
                                // ignore: use_build_context_synchronously
                                context,
                                title: 'Final Confirmation',
                                content:
                                    'This action cannot be undone. Delete this user?',
                              );

                              if (confirm2 == true) {
                                // Delete the user from Firestore
                                await FirestoreService.instance.deleteData(
                                  documentPath: 'users/${user['id']}',
                                );

                                // Show success toast notification
                                Fluttertoast.showToast(
                                  msg: "User deleted successfully",
                                  textColor: AppColors().white,
                                  backgroundColor:
                                      AppColors().orange.withOpacity(0.8),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.montserratAlternates(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.montserratAlternates(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserratAlternates(
                color: AppColors().navy,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.montserratAlternates(
                color: AppColors().red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
