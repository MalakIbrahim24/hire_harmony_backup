import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ServicesList extends StatelessWidget {
  final String userId; // User ID to access the document
  final String subCollection; // Sub-collection inside the user's document
  final String action; // Field like 'deletedAt' or similar

  const ServicesList({
    super.key,
    required this.userId,
    required this.subCollection,
    required this.action,
  });

  /// Converts Firestore Timestamp to readable date format
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('dd MMM yyyy, HH:mm:ss').format(timestamp.toDate());
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreService.instance.getDataStream<Map<String, dynamic>>(
        collectionPath:
            'users/$userId/$subCollection', // Path to sub-collection
        builder: (data, documentId) => data, // Return document data
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No services found',
              style: GoogleFonts.montserratAlternates(
                color: AppColors().navy,
              ),
            ),
          );
        }

        final services = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors().navy.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service: ${service['service_name'] ?? 'N/A'}',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors().navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Employee: ${service['employee_name'] ?? 'N/A'}',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 14,
                        color: AppColors().navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Deleted At: ${formatTimestamp(service[action])}',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 14,
                        color: AppColors().navy,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
