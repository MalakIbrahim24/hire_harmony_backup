import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/services/firestore_services.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class ServicesList extends StatelessWidget {
  final String collection;
  final String action;

  const ServicesList({
    super.key,
    required this.collection,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreService.instance.getDataStream<Map<String, dynamic>>(
        collectionPath: collection,
        builder: (data, documentId) => data,
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
                  color: AppColors().navy.withValues(alpha:0.2),
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
                      'Service: ${service['service_name']}',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors().navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Employee: ${service['employee_name']}',
                      style: GoogleFonts.montserratAlternates(
                        fontSize: 14,
                        color: AppColors().navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Deleted At: ${service[action]}',
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
